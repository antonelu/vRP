local config = {
    maxExp = 100
    maxLevel = 5     
}

local playerCache = {};
function vRP.setPlayerJob(user_id, job)
    if not playerCache[user_id] then
        playerCache[user_id] = {playerJob = job, jobSkills = {}}
    end

    if playerCache[user_id] then
        exports.oxmysql:query("UPDATE vrp_users SET job = @job WHERE id = @user_id", {["@job"] = job, ["@user_id"] = user_id})
        playerCache[user_id].playerJob = job
    end

    Citizen.SetTimeout(50, function()
        exports.oxmysql:query("SELECT jobSkills FROM vrp_users WHERE id = @user_id", {["@user_id"] = user_id}, function(rows)
            local temporaryVariable = json.decode(rows[1].jobSkills)
            if rows[1].jobSkills ~= '' then 
                playerCache[user_id].jobSkills = json.decode(rows[1].jobSkills)

                if job == "Somer" then return end

                local tempName = nil
                for tempJobName in pairs(temporaryVariable) do
                    if job == tempJobName then
                        tempName = tempJobName
                    end
                end

                if job == tempName then
                    playerCache[user_id].jobSkills[job] = {
                        level = temporaryVariable[job].level,
                        experience = temporaryVariable[job].experience
                    }
                else    
                    playerCache[user_id].jobSkills[job] = {
                        level = 0,
                        experience = 0
                    }

                    exports.oxmysql:query("UPDATE vrp_users SET jobSkills = @jobSkills WHERE id = @user_id", {["@jobSkills"] = json.encode(playerCache[user_id].jobSkills), ["@user_id"] = user_id})
                end

                if temporaryVariable and tempName then
                    temporaryVariable = nil
                    tempName = nil
                end
            else
                if job == "Somer" then return end

                playerCache[user_id].jobSkills[job] = {
                    level = 0,
                    experience = 0
                }

                exports.oxmysql:query("UPDATE vrp_users SET jobSkills = @jobSkills WHERE id = @user_id", {["@jobSkills"] = json.encode(playerCache[user_id].jobSkills), ["@user_id"] = user_id})
            end
        end)
    end)
end

function vRP.getPlayerJob(user_id)
    if playerCache[user_id] then
        return playerCache[user_id].playerJob
    end
    return "Somer"
end

AddEventHandler("vRP:playerSpawn", function(user_id, player, first_spawn)
    exports.oxmysql:query("SELECT job FROM vrp_users WHERE id = @user_id", {["@user_id"] = user_id}, function(rows)
        local playerJob = tostring(rows[1].job)
        if playerJob then
            vRP.setPlayerJob(user_id, playerJob)
        end
    end)
end)

AddEventHandler("vRP:playerLeave", function(user_id, player)
    if playerCache[user_id] then
        exports.oxmysql:query("UPDATE vrp_users SET jobSkills = @jobSkills WHERE id = @user_id", {["@jobSkills"] = json.encode(playerCache[user_id].jobSkills), ["@user_id"] = user_id})
    end

    playerCache[user_id] = nil
end)

RegisterCommand("test1", function(source)
    vRP.setPlayerJob(vRP.getUserId(source), "Bucatar")
end)

RegisterCommand("test2", function(source)
    vRP.setPlayerJob(vRP.getUserId(source), "Maturator")
end)
