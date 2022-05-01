fx_version "cerulean"
games {"gta5"}

lua54 "yes"

client_scripts{ 
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"client.lua"
}

server_scripts{ 
	"@vrp/lib/utils.lua",
	"server.lua"
}