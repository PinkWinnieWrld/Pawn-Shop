fx_version 'cerulean'
game 'gta5'

name 'pawnshop'
author 'Winnie'
description 'Pawn Shop with random daily prices, okokBanking, ox_lib, ox_inventory, ox_target'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}
