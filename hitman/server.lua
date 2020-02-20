AddCommand("requesthit", function(player, amount, ...)
    local hit_player_name = table.concat({...}, " ") 
    -- local x, y = GetPlayerLocation(player)
    -- local nearestPlayer = GetNearestPlayer2D(x, y)
    if amount == nil then
        return CallRemoteEvent(player, 'KNotify:Send', "Provide an amount /requesthit 5000 Ben Dover", "#f00")
    end
    if hit_player_name == nil or hit_player_name == "" then
        return CallRemoteEvent(player, 'KNotify:Send', "Provide a player name /requesthit 5000 Ben Dover", "#f00")
    end
    if GetPlayerCash(player) < tonumber(amount) then
        return CallRemoteEvent(player, 'KNotify:Send', "You dont have enough cash for that hit", "#f00")
    end
    if PlayerData[player].job == "hitman" then
        CallRemoteEvent(player, "BRPUI:ShowHitmanRequestedHit", PlayerData[player].name, amount, hit_player_name)
    end
end)

AddCommand("hitman", function(player)
    PlayerData[player].job = "hitman"
end)
