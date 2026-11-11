fx_version "cerulean"
game "gta5"
author "https://discord.zykeresources.com"
description "Slash vehicle tires with melee weapons"
lua54 "yes"
version "2.0.2"

-- zyke_lib systems this resource uses, zyke_lib only waits for these while it starts
zyke_systems {
    "framework",
    "target",
    "notification",
}

-- Shows each player the language they picked, see zyke_lib's README
zyke_player_language "yes"

shared_scripts {
    "@zyke_lib/imports.lua",
    "shared/config.lua",
    "shared/functions.lua",
}

client_scripts {
    "client/movement.lua",
    "client/main.lua",
}

server_scripts {
    "server/can_checks.lua",
    "server/hooks.lua",
    "server/sounds.lua",
    "server/main.lua",
}

files {
    "locales/*.lua",
}

dependency "zyke_lib"