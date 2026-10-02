---@class StabWheel
---@field bone string
---@field index integer @ Tire index used by the tire burst natives

---@class StabTarget
---@field vehicle integer
---@field index integer
---@field offset vector3 @ Hub position local to the vehicle

---@class TireSlashedData
---@field source PlayerId @ Player who slashed the tire
---@field vehicle integer
---@field netId NetId
---@field tireIndex integer
---@field plate string
---@field coords vector3
---@field alarm boolean @ The vehicle was locked and its alarm went off