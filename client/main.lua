-- Marks every intact tire on nearby vehicles while a slashing weapon is held; aiming at one shows
-- the stab key there through zyke_lib interest points, and pressing it walks the player up beside
-- the tire to stab it

local stabKey = "zyke_stabwheels_stab"
local markerSet = "wheels"
---@type StabWheel[]
local wheels = {
    {bone = "wheel_lf", index = 0},
    {bone = "wheel_rf", index = 1},
    {bone = "wheel_lm1", index = 2},
    {bone = "wheel_rm1", index = 3},
    {bone = "wheel_lr", index = 4},
    {bone = "wheel_rr", index = 5},
    {bone = "wheel_lm2", index = 45},
    {bone = "wheel_lm3", index = 46},
    {bone = "wheel_rm2", index = 47},
    {bone = "wheel_rm3", index = 48},
}
-- Vehicles whose origin is further away than this get no markers
local searchDistance = 6.0
-- Metres from the player a tire can be stabbed at
local stabReach = 1.5
-- Markers show a little past the reach, so the player is guided over before they can stab
local markerDistance = 3.0
local refreshInterval = 250
-- A line of sight ray ending this close to a hub still sees it, since the tire wall sits in between
local sightTolerance = 0.5
local maxSpeed = 0.5
-- Metres out from the hub the player stands, so the stab lands on the tire wall
local standOffset = 0.7
local animDict, animClip = "melee@knife@streamed_core_fps", "ground_attack_on_spot"
-- Milliseconds into the stab the blade meets the tire
local stabHitMs = 550
-- Milliseconds into the stab it blends out, before the clip's idle tail
local stabExitMs = 1300
-- Lower is a slower, smoother blend back to standing once the stab ends
local animBlendOut = 3.0

---@type table<integer, true> @ Weapon hash -> can slash
local slashWeapons = {}
---@type table<integer, true> @ Model hash -> protected from slashing
local disabledModels = {}
---@type table<string, StabTarget>
local targets = {}
local stabbing = false

for weapon, enabled in pairs(Config.Settings.weapons) do
    if (enabled) then slashWeapons[joaat(weapon)] = true end
end

for i = 1, #Config.Settings.disabledVehicles do
    disabledModels[joaat(Config.Settings.disabledVehicles[i])] = true
end

---@param ped integer
---@return boolean canStab
local function canPedStab(ped)
    if (stabbing) then return false end
    if (IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) or IsPedRagdoll(ped) or IsPedSwimming(ped)) then return false end

    return slashWeapons[GetSelectedPedWeapon(ped)] == true
end

---@param vehicle integer
---@return boolean canStab
local function canStabVehicle(vehicle)
    if (not DoesEntityExist(vehicle)) then return false end
    if (disabledModels[GetEntityModel(vehicle)]) then return false end

    return GetEntitySpeed(vehicle) <= maxSpeed
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
---@param pedCoords vector3
---@param origin vector3
---@param ped integer
local function addWheelMarkers(markers, vehicle, pedCoords, origin, ped)
    for i = 1, #wheels do
        local wheel = wheels[i]
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
                    label = T("stabWheel"),
                    reach = stabReach,
                }
            end
        end
    end
end

local function refreshMarkers()
    targets = {}

    local ped = PlayerPedId()
    if (not canPedStab(ped)) then Z.clearInterestPoints(markerSet) return end

    local pedCoords = GetEntityCoords(ped)
    local origin = GetFinalRenderedCamCoord()
    local vehicles = GetGamePool("CVehicle")
    local markers = {}

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if (#(GetEntityCoords(vehicle) - pedCoords) <= searchDistance and canStabVehicle(vehicle)) then
            addWheelMarkers(markers, vehicle, pedCoords, origin, ped)
        end
    end

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

---@param target StabTarget
local function stabWheel(target)
    local vehicle = target.vehicle
    if (not Z.loadDict(animDict)) then return end

    local ped = PlayerPedId()
    local offset = target.offset
    local hub = GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)
    local standCoords = getStandCoords(target)
    local heading = GetHeadingFromVector_2d(hub.x - standCoords.x, hub.y - standCoords.y)

    -- A blocked walk still stabs from wherever the player stopped, as long as the tire is in reach
    local arrived = WalkPedToCoords(ped, standCoords, heading, vehicle)
    if (not arrived and (not DoesEntityExist(vehicle) or GetHorizontalDistance(GetEntityCoords(ped), hub) > stabReach)) then return end
    if (not canStabVehicle(vehicle) or not slashWeapons[GetSelectedPedWeapon(ped)]) then return end

    TurnPedToFace(ped, hub)

    -- Blended out after the stab rather than cut off with a task clear, since the clip idles at the end
    TaskPlayAnim(ped, animDict, animClip, 8.0, animBlendOut, -1, 0, 0.0, false, false, false)
    Wait(stabHitMs)

    if (DoesEntityExist(vehicle) and not IsVehicleTyreBurst(vehicle, target.index, false)) then
        -- Bulletproof tires still get the stab, so the player finds out by trying
        if (GetVehicleTyresCanBurst(vehicle)) then
            SetVehicleTyreBurst(vehicle, target.index, false, 100.0)
            Z.notify("wheelBursted")
        else
            Z.notify("wheelBulletproof")
        end
    end

    Wait(stabExitMs - stabHitMs)
    StopAnimTask(ped, animDict, animClip, animBlendOut)
    RemoveAnimDict(animDict)
end

local function onStabPressed()
    -- Read at the press, so it is the tire shown on the marker right now
    local id = Z.getAimedInterestPoint(markerSet)
    local target = id and targets[id]
    if (not target) then return end
    if (not canPedStab(PlayerPedId()) or not canStabVehicle(target.vehicle)) then return end
    if (IsVehicleTyreBurst(target.vehicle, target.index, false)) then return end

    -- Set before anything yields, so a second press can not start another stab
    stabbing = true
    Z.clearInterestPoints(markerSet)

    -- Key callbacks come in from zyke_lib and the stab yields through the walk and the animation
    CreateThread(function()
        stabWheel(target)
        stabbing = false
    end)
end

Z.registerKey(stabKey, "E", T("keybind:stabWheel"), onStabPressed)

CreateThread(function()
    while (true) do
        refreshMarkers()
        Wait(refreshInterval)
    end
end)