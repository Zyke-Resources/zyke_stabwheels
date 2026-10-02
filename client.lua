-- Marks every intact tire on nearby vehicles while a slashing weapon is held; aiming at one shows
-- the stab key there through zyke_lib interest points

---@class StabWheel
---@field bone string
---@field index integer @ Tire index used by the tire burst natives

---@class StabTarget
---@field vehicle integer
---@field index integer

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
local animDict, animClip = "melee@knife@streamed_core_fps", "ground_attack_on_spot"

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

                targets[id] = {vehicle = vehicle, index = wheel.index}
                markers[#markers + 1] = {
                    id = id,
                    entity = vehicle,
                    offset = GetOffsetFromEntityGivenWorldCoords(vehicle, hub.x, hub.y, hub.z),
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

---@param target StabTarget
local function stabWheel(target)
    -- Set before the dict load yields, so a second press can not start another stab
    stabbing = true
    Z.clearInterestPoints(markerSet)

    local ped = PlayerPedId()
    if (not Z.loadDict(animDict)) then stabbing = false return end

    TaskPlayAnim(ped, animDict, animClip, 8.0, -9.0, 1.8, 15, 1.0, false, false, false)
    Wait(550)

    if (DoesEntityExist(target.vehicle) and not IsVehicleTyreBurst(target.vehicle, target.index, false)) then
        SetVehicleTyreBurst(target.vehicle, target.index, false, 100.0)
        Z.notify("wheelBursted")
    end

    Wait(750)
    ClearPedTasks(ped)
    RemoveAnimDict(animDict)
    stabbing = false
end

local function onStabPressed()
    -- Read at the press, so it is the tire shown on the marker right now
    local id = Z.getAimedInterestPoint(markerSet)
    local target = id and targets[id]
    if (not target) then return end
    if (not canPedStab(PlayerPedId()) or not canStabVehicle(target.vehicle)) then return end
    if (IsVehicleTyreBurst(target.vehicle, target.index, false)) then return end

    -- Key callbacks come in from zyke_lib and the stab yields until the animation is done
    CreateThread(function()
        stabWheel(target)
    end)
end

Z.registerKey(stabKey, "E", T("keybind:stabWheel"), onStabPressed)

CreateThread(function()
    while (true) do
        refreshMarkers()
        Wait(refreshInterval)
    end
end)