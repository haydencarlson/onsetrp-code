
function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end

AddRemoteEvent("GetInitialHud", function(player)
    playername = GetPlayerName(player)
    hunger = math.ceil(PlayerData[player].hunger)
    thirst = math.ceil(PlayerData[player].thirst)
    cash = GetPlayerCash(player)
    bank = PlayerData[player].bank_balance
    job = PlayerData[player].job
    CallRemoteEvent(player, "hud:update", playername, hunger, thirst, cash, bank, job)
end)
