fx_version "cerulean"
game "gta5"
author "https://discord.zykeresources.com"
description "Slash vehicle tires with melee weapons"
lua54 "yes"
version "2.0.0"

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