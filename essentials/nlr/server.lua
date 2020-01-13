AddEvent("GetDeathPos", function(player)
    if PlayerData[player] ~= nil and PlayerData[player].accountid ~= nil then
        local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE id = ?;",
            PlayerData[player].accountid)
        mariadb_async_query(sql, query, DeathPos, player)
    end
end)

function DeathPos(player)
    if mariadb_get_row_count() ~= 0 then
        local result = mariadb_get_assoc(1) 
        local pos = json_decode(result['death_pos'])
        local x = pos['x']
        local y = pos['y']
        local z = pos['z']
        local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if dist < 6000 and not IsPlayerDead(player) then
            CallRemoteEvent(player, 'KNotify:Send', "Turn around you are breaking NLR!", "#f00")
        end
        if dist < 750 and not IsPlayerDead(player) then
            Delay(2000, function(player)
            SetPlayerLocation(player, 211882, 175167, 1307)
            CallRemoteEvent(player, 'KNotify:Send', "You were teleported back to spawn for breaking NLR.", "#f00")
            end, player)
        end
    end
end

CreateTimer(function(player)
    for k, v in pairs(GetAllPlayers()) do  
        CallEvent("GetDeathPos", v)	
    end
end, 5000)

function SetDeathPosition(player)
    local medic = false
    for k,v in pairs(GetAllPlayers()) do
        if player ~= v and PlayerData[v].job == "medic" then
            medic = true
        end
        break
    end
    if (medic ~= true) then
        local x, y, z = GetPlayerLocation(player)
        PlayerData[player].death_pos = {x= x, y= y, z= z}
        local query = mariadb_prepare(sql, "UPDATE accounts SET death_pos = '?' WHERE id = ?;", 
        json_encode(PlayerData[player].death_pos),
        PlayerData[player].accountid)
        mariadb_query(sql, query)
        SetPlayerPropertyValue(player, "nlr", 1, true)
        CallRemoteEvent(player, 'KNotify:Send', "You are now under new life rule.", "#f00")
        CallEvent("RemoveNlr", player)
    end
end
AddEvent("OnPlayerDeath", SetDeathPosition)

AddEvent("RemoveNlr", function(player)
    Delay(30000, function(player)
        SetPlayerPropertyValue(player, "nlr", 0, true)
        PlayerData[player].death_pos = {}
        local query = mariadb_prepare(sql, "UPDATE accounts SET death_pos = '?' WHERE id = ?;", 
        "{}",
        PlayerData[player].accountid)
        mariadb_query(sql, query)
        CallRemoteEvent(player, 'KNotify:Send', "Your new life rule expired.", "#0f0")
    end, player)
end)