return {
    -- Notifications
    ["wheelBursted"] = {msg = "轮胎已被割破。", type = "success"},
    ["wheelBulletproof"] = {msg = "轮胎经过加固，无法刺破。", type = "error"},
    ["vehicleProtected"] = {msg = "这辆车的轮胎无法被割破。", type = "error"},
    ["vehicleMoving"] = {msg = "车辆必须先停下。", type = "error"},
    ["stabFailed"] = {msg = "未能割破轮胎。", type = "error"},

    -- Prompts
    ["stabWheel"] = "割破轮胎",
    ["hint:vehicleProtected"] = "无法割破",
    ["hint:vehicleMoving"] = "车辆正在移动",
    ["stabCancel"] = "取消",

    -- Keybinds
    ["keybind:stabWheel"] = "割破车辆轮胎",
    ["keybind:cancelStab"] = "取消走向轮胎",
}