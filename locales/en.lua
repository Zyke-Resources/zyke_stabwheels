return {
    -- Notifications
    ["wheelBursted"] = {msg = "Tire slashed.", type = "success"},
    ["wheelBulletproof"] = {msg = "The tire is reinforced and won't puncture.", type = "error"},
    ["vehicleProtected"] = {msg = "This vehicle's tires can't be slashed.", type = "error"},
    ["vehicleMoving"] = {msg = "The vehicle has to be stopped first.", type = "error"},
    ["stabFailed"] = {msg = "Couldn't slash the tire.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Slash tire",
    ["hint:vehicleProtected"] = "Can't be slashed",
    ["hint:vehicleMoving"] = "Vehicle is moving",
    ["stabCancel"] = "Cancel",

    -- Keybinds
    ["keybind:stabWheel"] = "Slash a vehicle tire",
    ["keybind:cancelStab"] = "Cancel walking to a tire",
}