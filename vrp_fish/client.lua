local vRP = Proxy.getInterface("vRP")
local getJob, inJob, sellFish, text = vec3(-1038.3117675781,-1396.9108886719,5.5531935691833), false, false, false
local fishLoc = {
	vec3(-1013.9536743164,-1396.5150146484,5.1844420433044)
}
local shopsLoc = {
	vec3(128.1410369873, -1286.1120605469, 29.28103637695),
	vec3(-47.522762298584,-1756.85717773438,29.421010971069),
	vec3(25.7454013824463,-1345.26232910156,29.4970207214355),
	vec3(1135.57678222656,-981.78125,46.4157981872559),
	vec3(1163.53820800781,-323.541320800781,69.2050552368164),
	vec3(374.190032958984,327.506713867188,103.566368103027),
	vec3(2555.35766601563,382.16845703125,108.622947692871),
	vec3(2676.76733398438,3281.57788085938,55.2411231994629),
	vec3(1960.50793457031,3741.84008789063,32.343738555908),
	vec3(1393.23828125,3605.171875,34.9809303283691),
	vec3(1166.18151855469,2709.35327148438,38.15771484375),
	vec3(547.987609863281,2669.7568359375,42.1565132141113),
	vec3(1698.30737304688,4924.37939453125,42.0636749267578),
	vec3(1729.54443359375,6415.76513671875,35.0372200012207),
	vec3(-3243.9013671875,1001.40405273438,12.8307056427002),
	vec3(-2967.8818359375,390.78662109375,15.0433149337769),
	vec3(-3041.17456054688,585.166198730469,7.90893363952637),
	vec3(-1820.55725097656,792.770568847656,138.113250732422),
	vec3(-1486.76574707031,-379.553985595703,40.163387298584),
	vec3(-1223.18127441406,-907.385681152344,12.3263463973999),
	vec3(-707.408996582031,-913.681701660156,19.215585708618),
}

Citizen.CreateThread(function()
	local ticks = 512
	function anim()
		vRP.playAnim({true, {task="WORLD_HUMAN_STAND_FISHING"}, false})
		Wait(3000)
		vRP.stopAnim({false})
		sellFish = true
	end
	while true do Citizen.Wait(ticks)
		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player)
		if #(getJob - pCoords) < 5 then ticks = 1
			local x, y, z = getJob.x, getJob.y, getJob.z
			DrawText3D(x, y, z + 0.50, "~g~PESCAR JOB", 0.85, 2)
			if #(getJob - pCoords) < 2 then ticks = 1
				DrawText3D(x, y, z + 0.40, "~w~Apasa ~g~E ~w~pentru a lucra ca ~g~Pescar", 0.65, 0)
				if IsControlJustPressed(0, 51) then 
					if not inJob then inJob = true
						TriggerServerEvent("fisher:startJob", inJob)
					else inJob = false
						TriggerServerEvent("fisher:startJob", inJob)
					end
				end
			end
		else 
			ticks = 512 
		end

		if inJob then
			for i, v in pairs(fishLoc) do
				local fishLocs = vec3(v[1], v[2], v[3])
				if #(fishLocs - pCoords) < 5 then ticks = 1
					local x, y, z = v[1], v[2], v[3]
					DrawText3D(x, y, z + 0.50, "~g~ZONA DE PESCUIT", 0.85, 2)
					if #(fishLocs - pCoords) < 2 then ticks = 1
						DrawText3D(x, y, z + 0.40, "~w~Apasa ~g~E ~w~pentru a lucra ca ~g~Pescar", 0.65, 0)
						if IsControlJustPressed(0, 51) then anim() 
							TriggerServerEvent("fisher:getFish", math.random(1,5))
						end
					end
				end
			end
		end

		if inJob and sellFish then
			for i, v in pairs(shopsLoc) do
				local shopsLocs = vec3(v[1], v[2], v[3])
				if #(shopsLocs - pCoords) < 5 then ticks = 1
					local x, y, z = v[1], v[2], v[3]
					DrawText3D(x, y, z + 0.50, "~g~VINDE PESTE", 0.85, 2)
					if #(shopsLocs - pCoords) < 2 then ticks = 1
						DrawText3D(x, y, z + 0.40, "~w~Apasa ~g~E ~w~pentru a vinde ~g~Pestele", 0.65, 0)
						if IsControlJustPressed(0, 51) then sellFish = false
							TriggerServerEvent("fisher:sellFish")
						end
					end
				end
			end
		end
	end
end)


function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end