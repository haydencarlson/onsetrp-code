
function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end

AddRemoteEvent("GetInitialHud", function(player)
    playername = GetPlayerName(player)
    hunger = math.ceil(PlayerData[player].hunger)
    thirst = math.ceil(PlayerData[player].thirst)
    cash = PlayerData[player].cash
    bank = PlayerData[player].bank_balance
    job = PlayerData[player].job
    CallRemoteEvent(player, "hud:update", playername, hunger, thirst, cash, bank, job)
end)

AddRemoteEvent("makeWanted", function(player)
    SetPlayerPropertyValue(player, "isWanted", 1, true)
    AddPlayerChat(player, "You are wanted!")
    Delay(80000, function()
        SetPlayerPropertyValue(player, "isWanted", 0, true)
        AddPlayerChat(player, "You escaped the law.")
    end)
end)

AddEvent("OnScriptError", function(message)
    AddPlayerChat(message)
end)

