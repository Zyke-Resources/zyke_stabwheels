-- Optional zyke_sounds playback attached to the vehicle, so every nearby client hears the tire
local settings = Config.Settings.sounds

---@param key "slash" | "blocked"
---@param vehicle integer
function PlayStabSound(key, vehicle)
    if (settings.enabled ~= true or not Z.isResourceStarted("zyke_sounds")) then return end

    local sound = settings.sounds[key]
    if (type(sound) ~= "table") then return end

    exports["zyke_sounds"]:PlaySoundOnEntity(vehicle, nil, sound.name, sound.volume, sound.distance, false)
end