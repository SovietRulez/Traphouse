fx_version 'cerulean'
game 'gta5'
author 'SovietRulez#0001/ fork of https://github.com/mrmicheall/esx_traphouse'
description 'qb-traps'
version '1.0.0'

shared_scripts { 
	'@qb-core/import.lua',
	'config.lua'
}

client_scripts {
    'client/main.lua',
	'config.lua'
}

server_script 'server/main.lua'

