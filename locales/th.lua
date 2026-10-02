return {
    -- Notifications
    ["wheelBursted"] = {msg = "กรีดยางแล้ว", type = "success"},
    ["wheelBulletproof"] = {msg = "ยางนี้เสริมความแข็งแรง กรีดไม่เข้า", type = "error"},
    ["vehicleProtected"] = {msg = "ยางของรถคันนี้กรีดไม่ได้", type = "error"},
    ["vehicleMoving"] = {msg = "รถต้องจอดนิ่งก่อน", type = "error"},
    ["stabFailed"] = {msg = "กรีดยางไม่สำเร็จ", type = "error"},

    -- Prompts
    ["stabWheel"] = "กรีดยาง",
    ["hint:vehicleProtected"] = "กรีดไม่ได้",
    ["hint:vehicleMoving"] = "รถกำลังเคลื่อนที่",
    ["stabCancel"] = "ยกเลิก",

    -- Keybinds
    ["keybind:stabWheel"] = "กรีดยางรถ",
    ["keybind:cancelStab"] = "ยกเลิกการเดินไปที่ยาง",
}