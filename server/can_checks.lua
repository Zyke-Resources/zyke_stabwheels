-- Editable gate for slashing tires; return true to allow, or false and a locale key to deny
-- Jobs, gangs, cooldowns or item checks fit here. Distance, the held weapon, protected vehicles and
-- vehicle motion are already checked in server/main.lua before this runs

---@param plyId PlayerId
---@param vehicle integer @ Vehicle whose tire is being slashed
---@param tireIndex integer
---@return boolean allowed
---@return string? reason
function CanSlashTire(plyId, vehicle, tireIndex)
    return true
end