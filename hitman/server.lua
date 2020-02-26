local activeJobs = {}
AddCommand("requesthit", function(player, amount, id)
    if PlayerData[player].job == "hitman" then
        return CallRemoteEvent(player, 'KNotify:Send', "You cant request a hit as a hitman", "#f00")
    end
    if PlayerData[tonumber(id)] == nil then
        return CallRemoteEvent(player, 'KNotify:Send', "Invalid Player ID", "#f00")
    end
    local hit_player_id = id
    local hitman = GetHitmanNearby(player)
    if hitman == nil then
        return CallRemoteEvent(player, 'KNotify:Send', "No Hitman nearby", "#f00")
    end

    if amount == nil then
        return CallRemoteEvent(player, 'KNotify:Send', "Provide an amount /requesthit 5000 Ben Dover", "#f00")
    end
    if GetPlayerCash(player) < tonumber(amount) then
        return CallRemoteEvent(player, 'KNotify:Send', "You dont have enough cash for that hit", "#f00")
    end
    CallRemoteEvent(player, 'KNotify:Send', "Hit has been requested.", "#0f0")
    CallRemoteEvent(hitman, "BRPUI:ShowHitmanRequestedHit", PlayerData[player].name, amount, PlayerData[tonumber(id)].name, PlayerData[tonumber(id)].job, id, player)
end)

function GetHitmanNearby(player)
    local x, y, z = GetPlayerLocation(player)
    local playerInRange = GetPlayersInRange3D(x, y, z, 250)
    if playerInRange ~= nil then
        for k, v in pairs(playerInRange) do
            if PlayerData[v].job == "hitman" then
                return v
            end
        end
    end
    return nil
end

AddEvent("OnPlayerDeath", function(player, instigator)
    for k, v in pairs(activeJobs) do
        if tonumber(v['target']) == player and tonumber(v['hitman']) == instigator then
            AddBalanceToAccount(tonumber(v['hitman']), "cash", tonumber(v['amount']))
            CallRemoteEvent(v['hitman'], 'KNotify:Send', "Hitman job completed. $" .. v['amount'] .. " added to account", "#0f0")
            table.remove(activeJobs, k)
        end
    end
end)

AddRemoteEvent("Hitman:AcceptJob", function(player, targetId, amount, requestId)
    local x, y, z = GetPlayerLocation(tonumber(targetId))
    CallRemoteEvent(player, "Hitman:AddTargetWaypoint", targetId, PlayerData[tonumber(targetId)].name, x, y, z)
    CallRemoteEvent(player, 'KNotify:Send', "Accepted Hit Job. Waypoint created", "#0f0")
    local halfPayAmount = math.tointeger(amount) / 2
    AddBalanceToAccount(tonumber(player), "cash", tonumber(halfPayAmount))
    RemoveBalanceFromAccount(tonumber(requestId), "cash", tonumber(amount))
    table.insert(activeJobs, {hitman = player, target = targetId, amount = halfPayAmount})
end)

AddRemoteEvent("Hitman:RequestWaypointUpdate", function(player, targetId)
    local x, y, z = GetPlayerLocation(tonumber(targetId))
    CallRemoteEvent(player, "Hitman:UpdateWaypoint", x, y, z)
end)

AddRemoteEvent("StartHitmanJob", function(player)
    PlayerData[player].job = "hitman"
    UpdateClothes(player)
end)

AddRemoteEvent("StopHitmanJob", function(player)
    PlayerData[player].job = ""
    UpdateClothes(player)
end)

AddCommand("hitman", function(player)
    PlayerData[player].job = "hitman"
end)
