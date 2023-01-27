fx_version 'bodacious'
game 'gta5'
description 'Sogolisica'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/vehicleshop.lua',
	'server/garage.lua'
}

client_scripts { 
	'config.lua',
	'client/vehicleshop.lua',
	'client/garage.lua'
}

ui_page 'html/index.html'

files {
	'html/js/main.js',
	'html/index.html',
	'html/css/main.css',
	'html/img/container.png',
	'html/img/Logo.png',
	'html/path.png'
}