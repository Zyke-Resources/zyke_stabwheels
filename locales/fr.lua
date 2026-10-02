return {
    -- Notifications
    ["wheelBursted"] = {msg = "Pneu crevé.", type = "success"},
    ["wheelBulletproof"] = {msg = "Le pneu est renforcé et ne se perce pas.", type = "error"},
    ["vehicleProtected"] = {msg = "Les pneus de ce véhicule ne peuvent pas être crevés.", type = "error"},
    ["vehicleMoving"] = {msg = "Le véhicule doit d’abord être à l’arrêt.", type = "error"},
    ["stabFailed"] = {msg = "Impossible de crever le pneu.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Crever le pneu",
    ["hint:vehicleProtected"] = "Impossible à crever",
    ["hint:vehicleMoving"] = "Véhicule en mouvement",
    ["stabCancel"] = "Annuler",

    -- Keybinds
    ["keybind:stabWheel"] = "Crever le pneu d’un véhicule",
    ["keybind:cancelStab"] = "Annuler l’approche d’un pneu",
}