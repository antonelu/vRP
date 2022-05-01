fx_version 'cerulean'
games { 'gta5' }
author 'warfa'
lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    '@vrp/client/Tunnel.lua',
    '@vrp/client/Proxy.lua',

    'utils/utils.lua',
    'client.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}
