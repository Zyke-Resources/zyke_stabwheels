-- Marks every intact tire on nearby vehicles while a slashing weapon is held; aiming at one shows
-- the stab key there through zyke_lib interest points, and pressing it walks the player up beside
-- the tire to stab it. The server validates the hit and bursts the tire on the vehicle's owner

local stabKey = "zyke_stabwheels_stab"
local cancelKey = "zyke_stabwheels_cancel"
local cancelMouseKey = "zyke_stabwheels_cancelmouse"
local cancelPromptId = "cancelStab"
local markerSet = "wheels"
-- Vehicles whose origin is further away than this get no markers
local searchDistance = 6.0
-- Metres from the player a tire can be stabbed at
local stabReach = 1.5
-- Markers show a little past the reach, so the player is guided over before they can stab
local markerDistance = 3.0
local refreshInterval = 250
-- A line of sight ray ending this close to a hub still sees it, since the tire wall sits in between
local sightTolerance = 0.5
-- Idle ring opacity of a tire that can't be slashed, so the ones that can stand out
local blockedOpacity = 0.5
-- Movement stick deflection that cancels the walk over
local cancelDeflection = 0.5
-- Metres out from the hub the player stands, so the stab lands on the tire wall
local standOffset = 0.7
local animDict, animClip = "melee@knife@streamed_core_fps", "ground_attack_on_spot"
-- Milliseconds into the stab the blade meets the tire
local stabHitMs = 550
-- Milliseconds into the stab it blends out, before the clip's idle tail
local stabExitMs = 1300
-- Lower is a slower, smoother blend back to standing once the stab ends
local animBlendOut = 3.0
local requestTimeout = 5000

local stabLabel = T("stabWheel")
---@type table<string, string> @ Block reason -> marker hint
local reasonHints = {
    vehicleProtected = T("hint:vehicleProtected"),
    vehicleMoving = T("hint:vehicleMoving"),
}

---@type table<string, StabTarget>
local targets = {}
local stabbing = false
local cancelled = false
local markersShown = false

---@param ped integer
---@return boolean canStab
local function canPedStab(ped)
    if (stabbing) then return false end
    if (IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) or IsPedRagdoll(ped) or IsPedSwimming(ped)) then return false end

    return IsSlashWeapon(GetSelectedPedWeapon(ped))
end

-- A hub on the far side of the vehicle gets no marker, so it can not be aimed at either
---@param point vector3
---@param origin vector3
---@param ped integer
---@return boolean visible
local function isHubVisible(point, origin, ped)
    local ray = StartExpensiveSynchronousShapeTestLosProbe(origin.x, origin.y, origin.z, point.x, point.y, point.z, 19, ped, 4)
    local _, hit, hitCoords = GetShapeTestResult(ray)

    return (hit ~= true and hit ~= 1) or #(hitCoords - point) <= sightTolerance
end

---@param markers InterestPoint[]
---@param vehicle integer
---@param reason? string @ Locale key for why the tires can't be slashed
---@param pedCoords vector3
---@param origin vector3
---@param ped integer
local function addWheelMarkers(markers, vehicle, reason, pedCoords, origin, ped)
    for i = 1, #StabWheels do
        local wheel = StabWheels[i]
        local boneIndex = GetEntityBoneIndexByName(vehicle, wheel.bone)

        if (boneIndex ~= -1 and not IsVehicleTyreBurst(vehicle, wheel.index, false)) then
            local hub = GetWorldPositionOfEntityBone(vehicle, boneIndex)

            if (#(hub - pedCoords) <= markerDistance and isHubVisible(hub, origin, ped)) then
                local id = vehicle .. ":" .. wheel.index
                local offset = GetOffsetFromEntityGivenWorldCoords(vehicle, hub.x, hub.y, hub.z)

                targets[id] = {vehicle = vehicle, index = wheel.index, offset = offset}
                markers[#markers + 1] = {
                    id = id,
                    entity = vehicle,
                    offset = offset,
                    key = "+" .. stabKey,
                    label = stabLabel,
                    hint = reason and reasonHints[reason] or nil,
                    opacity = reason and blockedOpacity or nil,
                    reach = stabReach,
                }
            end
        end
    end
end

local function refreshMarkers()
    targets = {}

    local ped = PlayerPedId()

    if (not canPedStab(ped)) then
        if (markersShown) then
            markersShown = false
            Z.clearInterestPoints(markerSet)
        end

        return
    end

    local pedCoords = GetEntityCoords(ped)
    local origin = GetFinalRenderedCamCoord()
    local vehicles = GetGamePool("CVehicle")
    local markers = {}

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if (#(GetEntityCoords(vehicle) - pedCoords) <= searchDistance) then
            local reason = GetStabBlockReason(vehicle)

            if (not reason or Config.Settings.alwaysShowMarkers) then
                addWheelMarkers(markers, vehicle, reason, pedCoords, origin, ped)
            end
        end
    end

    markersShown = true
    Z.setInterestPoints(markerSet, markers, {aim = true})
end

-- Beside the tire on the outside of the vehicle, so middle wheels work the same as the corners;
-- on the ground, since the walk task judges arrival against the ped's feet rather than the hub
---@param target StabTarget
---@return vector3 standCoords
local function getStandCoords(target)
    local offset = target.offset
    local side = offset.x >= 0.0 and 1.0 or -1.0
    local coords = GetOffsetFromEntityInWorldCoords(target.vehicle, offset.x + side * standOffset, offset.y, offset.z)
    local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1.0, false)

    return vector3(coords.x, coords.y, found and groundZ or coords.z)
end

-- The cancel keys set the flag; walking off with the movement keys sets it too, so it holds once
-- the keys are let go
---@return boolean cancelled
local function isWalkCancelled()
    if (math.abs(GetDisabledControlNormal(0, 30)) > cancelDeflection or math.abs(GetDisabledControlNormal(0, 31)) > cancelDeflection) then
        cancelled = true
    end

    return cancelled
end

---@param target StabTarget
---@return boolean ready @ The player reached the tire and faces it
local function moveToTire(target)
    local ped = PlayerPedId()
    local vehicle = target.vehicle
    local offset = target.offset
    local hub = GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)
    local standCoords = getStandCoords(target)
    local heading = GetHeadingFromVector_2d(hub.x - standCoords.x, hub.y - standCoords.y)

    cancelled = false
    Z.showPrompt(cancelPromptId, {"+" .. cancelKey, "+" .. cancelMouseKey}, T("stabCancel"))

    local arrived = WalkPedToCoords(ped, standCoords, heading, vehicle, isWalkCancelled)
    Z.hidePrompt(cancelPromptId)

    if (isWalkCancelled()) then return false end
    -- A blocked walk still stabs from wherever the player stopped, as long as the tire is in reach
    if (not arrived and (not DoesEntityExist(vehicle) or GetHorizontalDistance(GetEntityCoords(ped), hub) > stabReach)) then return false end
    if (not IsSlashWeapon(GetSelectedPedWeapon(ped))) then return false end

    TurnPedToFace(ped, hub)

    return true
end

-- Asks the server to burst the tire, or bursts it here for a vehicle only this client knows about
---@param target StabTarget
---@return string notification
local function requestSlash(target)
    local vehicle = target.vehicle
    local bulletproof = not GetVehicleTyresCanBurst(vehicle)
    local netId = Z.network.getNetId(vehicle)

    if (not netId) then
        if (bulletproof) then return "wheelBulletproof" end

        SetVehicleTyreBurst(vehicle, target.index, false, 100.0)

        return "wheelBursted"
    end

    local status, notification = Z.callback.request("zyke_stabwheels:SlashTire", {status = true, timeout = requestTimeout}, netId, target.index, bulletproof)
    if (not status.ok or type(notification) ~= "string") then return "stabFailed" end

    return notification
end

---@param target StabTarget
local function stabWheel(target)
    if (not Z.loadDict(animDict)) then return end
    if (not moveToTire(target)) then return end

    local vehicle = target.vehicle
    if (not DoesEntityExist(vehicle)) then return end

    -- The vehicle can drive off while the player walks over
    local reason = GetStabBlockReason(vehicle)
    if (reason) then Z.notify(reason) return end

    local ped = PlayerPedId()
    local exitAt = GetGameTimer() + stabExitMs

    -- Blended out after the stab rather than cut off with a task clear, since the clip idles at the end
    TaskPlayAnim(ped, animDict, animClip, 8.0, animBlendOut, -1, 0, 0.0, false, false, false)
    Wait(stabHitMs)

    if (DoesEntityExist(vehicle) and not IsVehicleTyreBurst(vehicle, target.index, false)) then
        Z.notify(requestSlash(target))
    end

    -- The server round trip comes out of the remaining stab time
    Wait(math.max(exitAt - GetGameTimer(), 0))
    StopAnimTask(ped, animDict, animClip, animBlendOut)
    RemoveAnimDict(animDict)
end

local function onStabPressed()
    -- Read at the press, so it is the tire shown on the marker right now
    local id = Z.getAimedInterestPoint(markerSet)
    local target = id and targets[id]
    if (not target or not DoesEntityExist(target.vehicle)) then return end
    if (not canPedStab(PlayerPedId())) then return end
    if (IsVehicleTyreBurst(target.vehicle, target.index, false)) then return end

    local reason = GetStabBlockReason(target.vehicle)

    if (reason) then
        Z.shakeInterestPoint(markerSet, id)
        Z.notify(reason)

        return
    end

    -- Set before anything yields, so a second press can not start another stab
    stabbing = true
    markersShown = false
    Z.clearInterestPoints(markerSet)

    -- Key callbacks come in from zyke_lib and the stab yields through the walk and the animation
    CreateThread(function()
        stabWheel(target)
        stabbing = false
    end)
end

local function onCancelPressed()
    if (stabbing) then cancelled = true end
end

Z.registerKey(stabKey, "E", T("keybind:stabWheel"), onStabPressed)
Z.registerKey(cancelKey, "X", T("keybind:cancelStab"), onCancelPressed)
Z.registerKey(cancelMouseKey, "MOUSE_RIGHT", T("keybind:cancelStab"), onCancelPressed, nil, "mouse_button")

-- The server sends this to whoever owns the vehicle, since only the owner's tire damage replicates
---@param netId NetId
---@param tireIndex integer
---@param alarmSeconds? integer @ Set when the vehicle is locked and its alarm should sound
RegisterNetEvent("zyke_stabwheels:BurstTire", function(netId, tireIndex, alarmSeconds)
    local vehicle = Z.network.getEntity(netId)
    if (not vehicle) then return end

    SetVehicleTyreBurst(vehicle, tireIndex, false, 100.0)
    if (not alarmSeconds) then return end

    SetVehicleAlarm(vehicle, true)
    SetVehicleAlarmTimeLeft(vehicle, alarmSeconds * 1000)
    StartVehicleAlarm(vehicle)
end)

CreateThread(function()
    while (true) do
        refreshMarkers()
        Wait(refreshInterval)
    end
end)