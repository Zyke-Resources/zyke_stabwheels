-- Validates every slash and bursts the tire on the client that owns the vehicle, since only the
-- owner's damage replicates to everyone else

-- Metres from the vehicle origin the player may stand, past the rear wheels of a long truck
local maxDistance = 8.0
-- One slash per player at most this often; the stab itself takes longer than this
local cooldownMs = 1000
local alarmSettings = Config.Settings.alarm

---@type table<PlayerId, integer> @ Game timer the player can slash again
local cooldowns = {}

-- Lock states 0 and 1 are no lock and unlocked
---@param vehicle integer
---@return boolean alarm
local function shouldSoundAlarm(vehicle)
    if (alarmSettings.enabled ~= true) then return false end

    return GetVehicleDoorLockStatus(vehicle) > 1
end

---@param plyId PlayerId
---@param vehicle integer
---@param tireIndex any
---@return string? reason @ Locale key the stab is refused with
local function validateSlash(plyId, vehicle, tireIndex)
    local ped = GetPlayerPed(plyId)
    if (not IsValidTireIndex(tireIndex)) then return "stabFailed" end
    if (GetVehiclePedIsIn(ped, false) ~= 0 or not IsSlashWeapon(GetSelectedPedWeapon(ped))) then return "stabFailed" end
    if (GetPlayerRoutingBucket(plyId) ~= GetEntityRoutingBucket(vehicle)) then return "stabFailed" end
    if (#(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > maxDistance) then return "stabFailed" end
    if (IsVehicleTyreBurst(vehicle, tireIndex, false)) then return "stabFailed" end

    local reason = GetStabBlockReason(vehicle)
    if (reason) then return reason end

    local allowed, denied = CanSlashTire(plyId, vehicle, tireIndex)
    if (not allowed) then return denied or "stabFailed" end

    return nil
end

---@param plyId PlayerId
---@param netId NetId
---@param tireIndex integer
---@param bulletproof boolean @ Read by the stabbing client, since the server has no native for it
---@return string notification @ Locale key for the stabbing player
Z.callback.register("zyke_stabwheels:SlashTire", function(plyId, netId, tireIndex, bulletproof)
    local now = GetGameTimer()
    if ((cooldowns[plyId] or 0) > now) then return "stabFailed" end

    cooldowns[plyId] = now + cooldownMs

    local vehicle = Z.network.getEntity(netId)
    if (not vehicle or GetEntityType(vehicle) ~= 2) then return "stabFailed" end

    local reason = validateSlash(plyId, vehicle, tireIndex)
    if (reason) then return reason end

    -- A bulletproof claim only spares the tire, so it needs no proof
    if (bulletproof == true) then
        PlayStabSound("blocked", vehicle)

        return "wheelBulletproof"
    end

    -- A vehicle nobody owns is burst by the stabbing player, who then owns it
    local owner = NetworkGetEntityOwner(vehicle)
    local alarm = shouldSoundAlarm(vehicle)

    TriggerClientEvent("zyke_stabwheels:BurstTire", owner > 0 and owner or plyId, netId, tireIndex, alarm and alarmSettings.seconds or nil)
    PlayStabSound("slash", vehicle)
    OnTireSlashed({
        source = plyId,
        vehicle = vehicle,
        netId = netId,
        tireIndex = tireIndex,
        plate = GetVehicleNumberPlateText(vehicle),
        coords = GetEntityCoords(vehicle),
        alarm = alarm,
    })

    return "wheelBursted"
end)

AddEventHandler("playerDropped", function()
    cooldowns[source] = nil
end)