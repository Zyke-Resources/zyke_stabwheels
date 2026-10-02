return {
    -- Notifications
    ["wheelBursted"] = {msg = "タイヤを切り裂いた。", type = "success"},
    ["wheelBulletproof"] = {msg = "このタイヤは強化されていて穴が開かない。", type = "error"},
    ["vehicleProtected"] = {msg = "この車両のタイヤは切り裂けない。", type = "error"},
    ["vehicleMoving"] = {msg = "先に車両を停止させる必要がある。", type = "error"},
    ["stabFailed"] = {msg = "タイヤを切り裂けなかった。", type = "error"},

    -- Prompts
    ["stabWheel"] = "タイヤを切り裂く",
    ["hint:vehicleProtected"] = "切り裂けない",
    ["hint:vehicleMoving"] = "車両が動いている",
    ["stabCancel"] = "キャンセル",

    -- Keybinds
    ["keybind:stabWheel"] = "車両のタイヤを切り裂く",
    ["keybind:cancelStab"] = "タイヤへの移動をキャンセル",
}