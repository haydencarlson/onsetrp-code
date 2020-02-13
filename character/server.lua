local PLAYER_SPAWN_POINT = {x = 204094, y = 180846, z = 1500}

AddRemoteEvent("ServerCharacterCreation", function(player)
    CallRemoteEvent(player, "characterize:ShowPanel", true)
end)

AddRemoteEvent("SetUIOpenStatus", function(player, isOpen) 
    CallRemoteEvent(player, "SetUIOpenStatusClient", isOpen)
end)

AddEvent("OnPlayerSpawn", function(player)
    if PlayerData[player] == nil then
        return
    end
    if PlayerData[player].clothing == nil then
        return
    end
    if PlayerData[player].clothing[1] == nil then
        return
    end
    UpdateClothes(player)
end)

function GetName(params)
    for k, v in pairs(params) do
        if v['name'] == 'name' then
            return v['value']
        end
    end
end
AddRemoteEvent("characterize:Submit", function(player, params, isCreating)
    if PlayerData[player].created == 0 then
        local name = GetName(json_decode(params))
        PlayerData[player].created = 1
        PlayerData[player].name = name
        CallRemoteEvent(player, 'characterize:ClientSubmit', true)
    end
    CallRemoteEvent(player, "characterize:HidePanel")
    UpdateClothes(player)
end)


AddRemoteEvent("UpdateClothingStreamIn", function(player, otherplayer)
    if PlayerData[otherplayer] ~= nil then
        if PlayerData[otherplayer].job == "medic" then
            CallRemoteEvent(player, "SetPlayerClothingToPreset", otherplayer, 17)
        elseif PlayerData[otherplayer].job == "police" then
            CallRemoteEvent(player, "SetPlayerClothingToPreset", otherplayer, 13)
        elseif PlayerData[otherplayer].job == "thief" then
            CallRemoteEvent(player, "SetPlayerClothingToPreset", otherplayer, 10)
        elseif PlayerData[otherplayer].job == "mayor" then
            CallRemoteEvent(player, "SetPlayerClothingToPreset", otherplayer, 18)
        elseif PlayerData[otherplayer].job == "cinema" then
            CallRemoteEvent(player, "SetPlayerClothingToPreset", otherplayer, 15)
        else
            playerhairscolor = PlayerData[otherplayer].clothing[2]
            playershirtcolor = PlayerData[otherplayer].clothing[7]
            playerpantscolor = PlayerData[otherplayer].clothing[8]
            CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 0, PlayerData[otherplayer].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
            CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 1, PlayerData[otherplayer].clothing[3], playershirtcolor[1], playershirtcolor[2], playershirtcolor[3], playershirtcolor[4])
            CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 4, PlayerData[otherplayer].clothing[4], playerpantscolor[1], playerpantscolor[2], playerpantscolor[3], playerpantscolor[4])
            CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 5, PlayerData[otherplayer].clothing[5], 0, 0, 0, 0)
            CallRemoteEvent(player, "ClientChangeClothing", otherplayer, 6, PlayerData[otherplayer].clothing[6])
        end
    end
end)

function UpdateClothes(player)
    if PlayerData[player].job == "medic" then
        CallRemoteEvent(player, "SetPlayerClothingToPreset", player, 17)
        for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
		    CallRemoteEvent(v, "SetPlayerClothingToPreset", player, 17)
        end
    elseif PlayerData[player].job == "police" then
        CallRemoteEvent(player, "SetPlayerClothingToPreset", player, 13)
        for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
		    CallRemoteEvent(v, "SetPlayerClothingToPreset", player, 13)
        end
    elseif PlayerData[player].job == "thief" then
        CallRemoteEvent(player, "SetPlayerClothingToPreset", player, 10)
        for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
            CallRemoteEvent(v, "SetPlayerClothingToPreset", player, 10)
        end
    elseif PlayerData[player].job == "mayor" then
        CallRemoteEvent(player, "SetPlayerClothingToPreset", player, 18)
        for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
            CallRemoteEvent(v, "SetPlayerClothingToPreset", player, 18)
        end
    elseif PlayerData[player].job == "cinema" then
        CallRemoteEvent(player, "SetPlayerClothingToPreset", player, 15)
        for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
            CallRemoteEvent(v, "SetPlayerClothingToPreset", player, 15)
        end
    else
        playerhairscolor = PlayerData[player].clothing[2]
        playershirtcolor = PlayerData[player].clothing[7]
        playerpantscolor = PlayerData[player].clothing[8]
        CallRemoteEvent(player, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
        CallRemoteEvent(player, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], playershirtcolor[1], playershirtcolor[2], playershirtcolor[3], playershirtcolor[4])
        CallRemoteEvent(player, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], playerpantscolor[1], playerpantscolor[2], playerpantscolor[3], playerpantscolor[4])
        CallRemoteEvent(player, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
        CallRemoteEvent(player, "ClientChangeClothing", player, 6, PlayerData[player].clothing[6])
        for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
            CallRemoteEvent(v, "ClientChangeClothing", player, 0, PlayerData[player].clothing[1], playerhairscolor[1], playerhairscolor[2], playerhairscolor[3], playerhairscolor[4])
            CallRemoteEvent(v, "ClientChangeClothing", player, 1, PlayerData[player].clothing[3], playershirtcolor[1], playershirtcolor[2], playershirtcolor[3], playershirtcolor[4])
            CallRemoteEvent(v, "ClientChangeClothing", player, 4, PlayerData[player].clothing[4], playerpantscolor[1], playerpantscolor[2], playerpantscolor[3], playerpantscolor[4])
            CallRemoteEvent(v, "ClientChangeClothing", player, 5, PlayerData[player].clothing[5], 0, 0, 0, 0)
            CallRemoteEvent(v, "ClientChangeClothing", player, 6, PlayerData[player].clothing[6])
        end
    end
end
AddRemoteEvent("CharacterChangeClothingItem", function(player, type, value)
    if type == "body" then
        PlayerData[player].clothing[6] = value
    end
    if type == "hair" then
        PlayerData[player].clothing[1] = value
    end
    if type == "shirt" then
        PlayerData[player].clothing[3] = value
    end
    if type == "pants" then
        PlayerData[player].clothing[4] = value
    end
    if type == "shoes" then
        PlayerData[player].clothing[5] = value
    end
    if type == "hair_color" then
        PlayerData[player].clothing[2] = value
    end
    if type == "pants_color" then
        PlayerData[player].clothing[8] = value
    end
    if type == "shirt_color" then
        PlayerData[player].clothing[7] = value
    end
end)

function getHairsColor(color)
    for k, v in pairs(hairsColor) do
        if k == color then
            return v
        end
    end
end

function getShoesModel(shoes)
    for k, v in pairs(shoesModel) do
        if k == shoes then
            return v
        end
    end
end

function getPantsModel(pants)
    for k, v in pairs(pantsModel) do
        if k == pants then
            return v
        end
    end
end

function getHairsModel(hairs)
    for k, v in pairs(hairsModel) do
        if k == hairs then
            return v
        end
    end
end

function getShirtsModel(shirts)
    for k, v in pairs(shirtsModel) do
        if k == shirts then
            return v
        end
    end
end

function GetClosePlayers(player, distance, blacklistedJob)
    local playerIds = {}
    local x, y, z = GetPlayerLocation(player)
    
    for playerId, v in pairs(GetStreamedPlayersForPlayer(player)) do
        local _x, _y, _z = GetPlayerLocation(playerId)
        
        if PlayerHaveName(playerId) and playerId ~= player and GetDistance3D(x, y, z, _x, _y, _z) < distance then
            if blacklistedJob == nil or PlayerData[playerId].job ~= blacklistedJob then
                playerIds[playerId] = PlayerData[playerId].name
            end
        end
    end
    
    return playerIds
end

function PlayerHaveName(player)
    return PlayerData[player] ~= nil and PlayerData[player].name ~= nil and PlayerData[player].steamname ~= nil
end

AddRemoteEvent("character:playerrdytospawn", function(player)
    SetPlayerLocation(player, PLAYER_SPAWN_POINT.x, PLAYER_SPAWN_POINT.y, PLAYER_SPAWN_POINT.z) -- MOTEL
    SetPlayerSpawnLocation(player, 212124, 159055, 1305, 90) -- HOSPITAL
end)
