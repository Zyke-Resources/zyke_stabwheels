return {
    -- Notifications
    ["wheelBursted"] = {msg = "Band lek gestoken.", type = "success"},
    ["wheelBulletproof"] = {msg = "De band is versterkt en gaat niet lek.", type = "error"},
    ["vehicleProtected"] = {msg = "De banden van dit voertuig kunnen niet lek gestoken worden.", type = "error"},
    ["vehicleMoving"] = {msg = "Het voertuig moet eerst stilstaan.", type = "error"},
    ["stabFailed"] = {msg = "Kon de band niet lek steken.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Band lekprikken",
    ["hint:vehicleProtected"] = "Kan niet lek gestoken worden",
    ["hint:vehicleMoving"] = "Voertuig rijdt",
    ["stabCancel"] = "Annuleren",

    -- Keybinds
    ["keybind:stabWheel"] = "Een voertuigband lekprikken",
    ["keybind:cancelStab"] = "Lopen naar een band annuleren",
}