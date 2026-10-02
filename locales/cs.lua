return {
    -- Notifications
    ["wheelBursted"] = {msg = "Pneumatika proříznuta.", type = "success"},
    ["wheelBulletproof"] = {msg = "Pneumatika je zesílená a nejde propíchnout.", type = "error"},
    ["vehicleProtected"] = {msg = "Pneumatiky tohoto vozidla nejde proříznout.", type = "error"},
    ["vehicleMoving"] = {msg = "Vozidlo musí nejdřív stát.", type = "error"},
    ["stabFailed"] = {msg = "Pneumatiku se nepodařilo proříznout.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Proříznout pneumatiku",
    ["hint:vehicleProtected"] = "Nejde proříznout",
    ["hint:vehicleMoving"] = "Vozidlo je v pohybu",
    ["stabCancel"] = "Zrušit",

    -- Keybinds
    ["keybind:stabWheel"] = "Proříznout pneumatiku vozidla",
    ["keybind:cancelStab"] = "Zrušit přesun k pneumatice",
}