fx_version 'cerulean'
game 'gta5'

description 'Weapons License System'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'qb-core',
    'qb-menu',
    'PolyZone'
}
