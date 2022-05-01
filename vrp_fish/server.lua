local Tunnel = module("lib/Tunnel")
local Proxy = module("lib/Proxy")

local vRP = Proxy.getInterface("vRP")
local vRPclient = Tunnel.getInterface("vRP","vrp_fish")

local userFish = {}
local hasJob = {}
local fishs = { -- puteti sa folositi ( reward = math.random(123,222) )
	[1] = {
		name = "Peste Common",
		reward = 23500
	},
	[2] = {
		name = "Peste Uncommon",
		reward = 23500
	},
	[3] = {
		name = "Peste Rar",
		reward = 23500
	},
	[4] = {
		name = "Peste Epic",
		reward = 23500
	},
	[5] = {
		name = "Peste Epic",
		reward = 23500
	}
}

RegisterNetEvent("fisher:startJob")
AddEventHandler("fisher:startJob", function(status)
	local player = source
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		if status then
			hasJob[user_id] = true
			vRPclient.notify(player,{"~w~Ai inceput jobul de ~g~Fisher"})
		else
			hasJob[user_id] = nil
			vRPclient.notify(player,{"~w~Ai terminat jobul de ~g~Fisher"})
		end
	end
end)

RegisterNetEvent("fisher:getFish")
AddEventHandler("fisher:getFish", function(random)
	local player = source
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		if hasJob[user_id] then
			userFish[user_id] = {name = fishs[random].name, reward = fishs[random].reward}
			local name = userFish[user_id].name
			local reward = userFish[user_id].reward
			if name and reward then
				vRPclient.notify(player,{"~w~Ti-a picat un ~y~"..name.." ~w~acum du-te la un magazin alimentar!"})
			end
		else
			DropPlayer(player, "Nu ai jobul de pescar!")
		end
	end
end)

RegisterNetEvent("fisher:sellFish")
AddEventHandler("fisher:sellFish", function()
	local player = source
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		if hasJob[user_id] then
			local name = userFish[user_id].name
			local reward = userFish[user_id].reward
			if name and reward then
				vRPclient.notify(player,{"~w~Ai vandut un ~y~"..name.." ~w~si pentru el ai primit ~g~"..reward.."$"})
				vRP.giveMoney({user_id, reward})
			end
			userFish[user_id] = nil
		else
			DropPlayer(player, "Nu ai jobul de pescar!")
		end
	end
end)