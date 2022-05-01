local vRP = Proxy.getInterface("vRP");
local vRPserver = Tunnel.getInterface("vrp_warehouse", "vrp_warehouse");
local inWarehouse, inQuest, doDelivery, isOwner = false, false, false, false;

local warehouse = {};
RegisterNetEvent("vRPclient:ServerToClient", function()
end)

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId();
        local playerCoords = GetEntityCoords(player);

        local config = config.warehouse;
        local threads = 1024;

        for i, v in pairs(config) do
            local joinX, joinY, joinZ = table.unpack(v.joinWare);
            local leaveX, leaveY, leaveZ = table.unpack(v.leaveWare);
            local missionX, missionY, missionZ = table.unpack(v.computerWare);

            if #(vec3(joinX, joinY, joinZ) - playerCoords) < 2.5 then threads = 0
                DrawText3D(joinX, joinY, joinZ + 0.8, "~w~"..v.name.." ~g~#"..i.."! ", 0.50, 0)
                DrawText3D(joinX, joinY, joinZ + 0.7, "~w~Owner: ~g~ [ID: 1]", 0.40, 0)
                if #(vec3(joinX, joinY, joinZ) - playerCoords) < 1 then threads = 0
                    DrawText3D(joinX, joinY, joinZ + 0.65, "~w~Apasa ~g~E ~w~pentru a intra", 0.40, 0)
                    if IsControlJustPressed(0, 51) then
                        vRPserver.accesWarehouse({}, function(enter)
                            if enter then
                                -- cand o sa am chef revin cu versiunea full. pana atunci asteptati :x (am sters multe utile)
                            end
                        end)
                    end
                end
            end
        end

        Citizen.Wait(threads)
    end
end)
