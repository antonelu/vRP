local Tunnel = module("lib/Tunnel");
local Proxy = module("lib/Proxy");

local vRP = Proxy.getInterface("vRP");
local vRPclient = Tunnel.getInterface("vRP", "vrp_warehouse");

local vRPserver = {};
Tunnel.bindInterface("vrp_warehouse", vRPserver);
Proxy.addInterface("vrp_warehouse", vRPserver);

local wPlayer = {};
local wHouse = {};

function vRPserver.()
    local player = source;
    local user_id = vRP.getUserId{player};
    if user_id ~= nil then
       -- cand o sa am chef revin cu versiunea full. pana atunci asteptati :x (am sters multe utile)

    else
        DropPlayer(player, "no id lol")
    end
end

function vRPserver.accesWarehouse()
    local player = source;
    local user_id = vRP.getUserId{player};
    if user_id ~= nil then
        if wPlayer[user_id] then
            return true
        else
            return false
        end
    else
        DropPlayer(player, "no id lol")
    end
end

AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
    local rows = exports.ghmattimysql:executeSync("SELECT * FROM vrp_warehouse WHERE user_id = @user_id", {["@user_id"] = user_id})
    if user_id ~= nil then
        if #rows > 0 then
            local uid = rows[1].user_id;
            if tonumber(uid) == tonumber(user_id) then
                wPlayer[user_id] = true
                if wPlayer[user_id] then
                    wHouse[uid] = {wid = tonumber(rows[1].id), id = tonumber(rows[1].user_id)}
                    if wHouse[uid] then
                        local wid = wHouse[uid].wid;
                        local id = wHouse[uid].id;
                        -- cand o sa am chef revin cu versiunea full. pana atunci asteptati :x (am sters multe utile)
                    end
                end
            else
                wPlayer[user_id] = nil
            end
        end
    else
        DropPlayer(source, "no id lol")
    end
end)
