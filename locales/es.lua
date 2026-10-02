return {
    -- Notifications
    ["wheelBursted"] = {msg = "Neumático rajado.", type = "success"},
    ["wheelBulletproof"] = {msg = "El neumático está reforzado y no se pincha.", type = "error"},
    ["vehicleProtected"] = {msg = "Los neumáticos de este vehículo no se pueden rajar.", type = "error"},
    ["vehicleMoving"] = {msg = "El vehículo tiene que estar detenido primero.", type = "error"},
    ["stabFailed"] = {msg = "No se pudo rajar el neumático.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Rajar neumático",
    ["hint:vehicleProtected"] = "No se puede rajar",
    ["hint:vehicleMoving"] = "Vehículo en movimiento",
    ["stabCancel"] = "Cancelar",

    -- Keybinds
    ["keybind:stabWheel"] = "Rajar el neumático de un vehículo",
    ["keybind:cancelStab"] = "Cancelar el acercamiento a un neumático",
}