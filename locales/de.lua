return {
    -- Notifications
    ["wheelBursted"] = {msg = "Reifen aufgeschlitzt.", type = "success"},
    ["wheelBulletproof"] = {msg = "Der Reifen ist verstärkt und lässt sich nicht durchstechen.", type = "error"},
    ["vehicleProtected"] = {msg = "Die Reifen dieses Fahrzeugs lassen sich nicht aufschlitzen.", type = "error"},
    ["vehicleMoving"] = {msg = "Das Fahrzeug muss zuerst stehen.", type = "error"},
    ["stabFailed"] = {msg = "Der Reifen konnte nicht aufgeschlitzt werden.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Reifen aufschlitzen",
    ["hint:vehicleProtected"] = "Nicht aufschlitzbar",
    ["hint:vehicleMoving"] = "Fahrzeug bewegt sich",
    ["stabCancel"] = "Abbrechen",

    -- Keybinds
    ["keybind:stabWheel"] = "Einen Fahrzeugreifen aufschlitzen",
    ["keybind:cancelStab"] = "Gang zum Reifen abbrechen",
}