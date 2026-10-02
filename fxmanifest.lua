fx_version "cerulean"
game "gta5"
author "https://discord.zykeresources.com"
description "Slash vehicle tires with melee weapons"
lua54 "yes"
version "1.0.4"

shared_scripts {
    "@zyke_lib/imports.lua",
    "shared/unlocked/config.lua",
}

client_scripts {
    "client/locked/movement.lua",
    "client/locked/main.lua",
}

files {
    "locales/*.lua",
}

dependency "zyke_lib"

escrow_ignore {
    "shared/unlocked/**/*",
    "locales/*",
}