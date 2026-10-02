return {
    -- Notifications
    ["wheelBursted"] = {msg = "Cauciuc tăiat.", type = "success"},
    ["wheelBulletproof"] = {msg = "Cauciucul este ranforsat și nu poate fi perforat.", type = "error"},
    ["vehicleProtected"] = {msg = "Cauciucurile acestui vehicul nu pot fi tăiate.", type = "error"},
    ["vehicleMoving"] = {msg = "Vehiculul trebuie mai întâi să stea pe loc.", type = "error"},
    ["stabFailed"] = {msg = "Cauciucul nu a putut fi tăiat.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Taie cauciucul",
    ["hint:vehicleProtected"] = "Nu poate fi tăiat",
    ["hint:vehicleMoving"] = "Vehiculul se mișcă",
    ["stabCancel"] = "Anulează",

    -- Keybinds
    ["keybind:stabWheel"] = "Taie cauciucul unui vehicul",
    ["keybind:cancelStab"] = "Anulează apropierea de un cauciuc",
}