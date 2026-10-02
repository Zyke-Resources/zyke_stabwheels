Config = Config or {}

Config.Settings = {
    -- Melee weapons that can slash tires; add any weapon name, or set one to false to stop it slashing
    weapons = {
        ["weapon_dagger"] = true,
        ["weapon_bottle"] = true,
        ["weapon_crowbar"] = true,
        ["weapon_hatchet"] = true,
        ["weapon_knife"] = true,
        ["weapon_machete"] = true,
        ["weapon_switchblade"] = true,
        ["weapon_battleaxe"] = true,
        ["weapon_stone_hatchet"] = true,
    },

    -- true marks every tire while a slashing weapon is out; a tire that can't be slashed says why on its
    -- marker, and shakes with a notification when used. false only marks tires that can be slashed right now
    alwaysShowMarkers = true,

    -- Vehicle classes whose tires can't be slashed, which also covers add-on vehicles in them
    -- 18 is emergency and 19 is military; class ids: https://docs.fivem.net/natives/?_0x29439776AAA00A62
    disabledClasses = {
        [18] = true,
    },

    -- Models protected on top of the classes above, by spawn name
    disabledVehicles = {
        "police",
        "police2",
        "police3",
        "police4",
        "policeb",
        "policet",
        "sheriff",
        "sheriff2",
        "fbi",
        "fbi2",
        "pranger",
        "ambulance",
        "firetruk",
        "riot",
        "riot2",
        "barracks",
        "barracks2",
        "barracks3",
        "crusader",
        "rhino",
    },

    -- Locked vehicles sound their alarm when one of their tires is slashed
    alarm = {
        enabled = true,
        seconds = 20,
    },

    -- Synced sounds through zyke_sounds, played on the vehicle; skipped while zyke_sounds is stopped
    -- Names are paths inside zyke_sounds/nui/sounds: copy extras/sounds/stabwheels there, then restart zyke_sounds
    -- Set a sound to false to mute it
    sounds = {
        enabled = true,
        sounds = {
            -- Plays when a tire is slashed and lets its air out
            slash = {name = "stabwheels/tire_slash.ogg", volume = 0.4, distance = 20.0},
            -- Plays when the blade fails to get through a bulletproof tire
            blocked = {name = "stabwheels/tire_stab_blocked.ogg", volume = 0.3, distance = 12.0},
        },
    },
}