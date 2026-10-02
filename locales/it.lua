return {
    -- Notifications
    ["wheelBursted"] = {msg = "Pneumatico squarciato.", type = "success"},
    ["wheelBulletproof"] = {msg = "Lo pneumatico è rinforzato e non si fora.", type = "error"},
    ["vehicleProtected"] = {msg = "Gli pneumatici di questo veicolo non possono essere squarciati.", type = "error"},
    ["vehicleMoving"] = {msg = "Il veicolo deve prima essere fermo.", type = "error"},
    ["stabFailed"] = {msg = "Impossibile squarciare lo pneumatico.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Squarcia lo pneumatico",
    ["hint:vehicleProtected"] = "Non squarciabile",
    ["hint:vehicleMoving"] = "Veicolo in movimento",
    ["stabCancel"] = "Annulla",

    -- Keybinds
    ["keybind:stabWheel"] = "Squarcia lo pneumatico di un veicolo",
    ["keybind:cancelStab"] = "Annulla l’avvicinamento a uno pneumatico",
}