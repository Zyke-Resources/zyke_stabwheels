-- Rules shared by the client markers and the server's validation, so both always agree on what can
-- be slashed

---@type StabWheel[]
StabWheels = {
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

-- Metres per second a vehicle may still be rolling at and have its tires slashed
local maxSpeed = 0.5

---@type table<integer, true> @ Weapon hash -> can slash
local slashWeapons = {}
---@type table<integer, true> @ Model hash -> protected from slashing
local disabledModels = {}
---@type table<integer, true> @ Tire index -> exists on some vehicle
local tireIndexes = {}

for weapon, enabled in pairs(Config.Settings.weapons) do
    if (enabled) then slashWeapons[joaat(weapon)] = true end
end

for i = 1, #Config.Settings.disabledVehicles do
    disabledModels[joaat(Config.Settings.disabledVehicles[i])] = true
end

for i = 1, #StabWheels do
    tireIndexes[StabWheels[i].index] = true
end

---@param weaponHash integer
---@return boolean canSlash
function IsSlashWeapon(weaponHash)
    return slashWeapons[weaponHash] == true
end

---@param tireIndex any
---@return boolean valid
function IsValidTireIndex(tireIndex)
    return tireIndexes[tireIndex] == true
end

-- Clients read the class directly; the server has no class native, so zyke_lib looks it up from a client
---@param vehicle integer
---@return boolean protected
local function isVehicleProtected(vehicle)
    local model = GetEntityModel(vehicle)
    if (disabledModels[model]) then return true end

    local class = Context == "client" and GetVehicleClass(vehicle) or Z.getVehicleClass(model)

    return Config.Settings.disabledClasses[class] == true
end

-- Why the vehicle's tires can't be slashed right now, as a locale key, or nil when they can
---@param vehicle integer
---@return "vehicleProtected" | "vehicleMoving" | nil reason
function GetStabBlockReason(vehicle)
    if (isVehicleProtected(vehicle)) then return "vehicleProtected" end
    if (#GetEntityVelocity(vehicle) > maxSpeed) then return "vehicleMoving" end

    return nil
end