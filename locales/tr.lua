return {
    -- Notifications
    ["wheelBursted"] = {msg = "Lastik kesildi.", type = "success"},
    ["wheelBulletproof"] = {msg = "Lastik güçlendirilmiş, delinmiyor.", type = "error"},
    ["vehicleProtected"] = {msg = "Bu aracın lastikleri kesilemez.", type = "error"},
    ["vehicleMoving"] = {msg = "Önce aracın durması gerekiyor.", type = "error"},
    ["stabFailed"] = {msg = "Lastik kesilemedi.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Lastiği kes",
    ["hint:vehicleProtected"] = "Kesilemez",
    ["hint:vehicleMoving"] = "Araç hareket ediyor",
    ["stabCancel"] = "İptal",

    -- Keybinds
    ["keybind:stabWheel"] = "Bir aracın lastiğini kes",
    ["keybind:cancelStab"] = "Lastiğe yürümeyi iptal et",
}