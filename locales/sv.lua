return {
    -- Notifications
    ["wheelBursted"] = {msg = "Däcket är sönderskuret.", type = "success"},
    ["wheelBulletproof"] = {msg = "Däcket är förstärkt och går inte att punktera.", type = "error"},
    ["vehicleProtected"] = {msg = "Det här fordonets däck går inte att skära sönder.", type = "error"},
    ["vehicleMoving"] = {msg = "Fordonet måste stå still först.", type = "error"},
    ["stabFailed"] = {msg = "Det gick inte att skära sönder däcket.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Skär sönder däcket",
    ["hint:vehicleProtected"] = "Kan inte skäras sönder",
    ["hint:vehicleMoving"] = "Fordonet rör sig",
    ["stabCancel"] = "Avbryt",

    -- Keybinds
    ["keybind:stabWheel"] = "Skär sönder ett fordonsdäck",
    ["keybind:cancelStab"] = "Avbryt gången fram till ett däck",
}