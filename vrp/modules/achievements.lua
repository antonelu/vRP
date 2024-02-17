local config = { 
    ["VIP"] = {
        reward = function(player, user_id)
            if player and user_id then
                local moneyReward = 6900
                if not user_id then return end

                vRP.giveMoney(user_id, moneyReward)
                vRPclient.notify(player, {"Ai facut un achievement nou!, ai deblocat VIP pentru primadata si ai primit $"..moneyReward})
            end
        end,
    },

    ["First Car"] = {
        reward = function(player, user_id)
            if player and user_id then
                local moneyReward = 5000
                if not user_id then return end

                vRP.giveMoney(user_id, moneyReward)
                vRPclient.notify(player, {"Ai facut un achievement nou!, ai deblocat Car pentru primadata si ai primit $"..moneyReward})
            end
        end,
    }
}

local achievementsData = {}
function vRP.addAchievement(user_id, achievement)
    if not config[achievement] then 
        return 
    end

    local player = vRP.getUserSource(user_id)
    if player then
        if not achievementsData[user_id] then
            achievementsData[user_id] = {
                [achievement] = true
            }

            exports.oxmysql:query("UPDATE vrp_users SET achievements = @achievements WHERE id = @user_id", {["@achievements"] = json.encode(achievementsData[user_id]), ["@user_id"] = user_id})
        end

        if achievementsData[user_id][achievement] then
            return
        end

        config[achievement].reward(player, user_id)
        achievementsData[user_id][achievement] = true

        TriggerClientEvent("vRPachievement:showAchievement", player, achievement)
        exports.oxmysql:query("UPDATE vrp_users SET achievements = @achievements WHERE id = @user_id", {["@achievements"] = json.encode(achievementsData[user_id]), ["@user_id"] = user_id})
    end
end

AddEventHandler("vRP:playerSpawn", function(user_id, player, first_spawn)
    exports.oxmysql:query("SELECT achievements FROM vrp_users WHERE id = @user_id", {["@user_id"] = user_id}, function(rows)
        achievementsData[user_id] = json.decode(rows[1].achievements)
    end)
end)

AddEventHandler("vRP:playerLeave", function(user_id, player)
    if achievementsData[user_id] then
        exports.oxmysql:query("UPDATE vrp_users SET achievements = @achievements WHERE id = @user_id", {["@achievements"] = json.encode(achievementsData[user_id]), ["@user_id"] = user_id})
    end

    achievementsData[user_id] = nil
end)

RegisterCommand("addAchievement", function(source, args)
    vRP.addAchievement(vRP.getUserId(source), "First Car")
end)