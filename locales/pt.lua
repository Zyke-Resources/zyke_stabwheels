return {
    -- Notifications
    ["wheelBursted"] = {msg = "Pneu furado.", type = "success"},
    ["wheelBulletproof"] = {msg = "O pneu é reforçado e não fura.", type = "error"},
    ["vehicleProtected"] = {msg = "Os pneus deste veículo não podem ser furados.", type = "error"},
    ["vehicleMoving"] = {msg = "O veículo precisa estar parado primeiro.", type = "error"},
    ["stabFailed"] = {msg = "Não foi possível furar o pneu.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Furar pneu",
    ["hint:vehicleProtected"] = "Não pode ser furado",
    ["hint:vehicleMoving"] = "Veículo em movimento",
    ["stabCancel"] = "Cancelar",

    -- Keybinds
    ["keybind:stabWheel"] = "Furar o pneu de um veículo",
    ["keybind:cancelStab"] = "Cancelar a ida até um pneu",
}