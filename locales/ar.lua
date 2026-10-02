return {
    -- Notifications
    ["wheelBursted"] = {msg = "تم ثقب الإطار.", type = "success"},
    ["wheelBulletproof"] = {msg = "الإطار مُعزَّز ولا يمكن ثقبه.", type = "error"},
    ["vehicleProtected"] = {msg = "لا يمكن ثقب إطارات هذه المركبة.", type = "error"},
    ["vehicleMoving"] = {msg = "يجب أن تتوقف المركبة أولاً.", type = "error"},
    ["stabFailed"] = {msg = "تعذّر ثقب الإطار.", type = "error"},

    -- Prompts
    ["stabWheel"] = "اثقب الإطار",
    ["hint:vehicleProtected"] = "لا يمكن ثقبه",
    ["hint:vehicleMoving"] = "المركبة تتحرك",
    ["stabCancel"] = "إلغاء",

    -- Keybinds
    ["keybind:stabWheel"] = "ثقب إطار مركبة",
    ["keybind:cancelStab"] = "إلغاء التوجه إلى إطار",
}