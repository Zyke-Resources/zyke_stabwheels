return {
    -- Notifications
    ["wheelBursted"] = {msg = "Opona przebita.", type = "success"},
    ["wheelBulletproof"] = {msg = "Opona jest wzmocniona i nie da się jej przebić.", type = "error"},
    ["vehicleProtected"] = {msg = "Opon tego pojazdu nie da się przebić.", type = "error"},
    ["vehicleMoving"] = {msg = "Pojazd musi najpierw stać w miejscu.", type = "error"},
    ["stabFailed"] = {msg = "Nie udało się przebić opony.", type = "error"},

    -- Prompts
    ["stabWheel"] = "Przebij oponę",
    ["hint:vehicleProtected"] = "Nie da się przebić",
    ["hint:vehicleMoving"] = "Pojazd jest w ruchu",
    ["stabCancel"] = "Anuluj",

    -- Keybinds
    ["keybind:stabWheel"] = "Przebij oponę pojazdu",
    ["keybind:cancelStab"] = "Anuluj podejście do opony",
}