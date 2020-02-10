
function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end

AddRemoteEvent("GetInitialHud", function(player)
    local playername = GetPlayerName(player)
    local hunger = math.ceil(PlayerData[player].hunger)
    local thirst = math.ceil(PlayerData[player].thirst)
    local cash = GetPlayerCash(player)
    local bank = PlayerData[player].bank_balance
    local job = PlayerData[player].job
    local time = GetServerTimeString()
    local timeplayed = GetPlayerTime(player)
    CallRemoteEvent(player, "hud:update", playername, hunger, thirst, cash, bank, job, time, FormatUpTime(timeplayed))
    CallRemoteEvent(player, "pc:update", time)
end)

AddEvent("ServerTimeUpdated", function(serverTime)
    for k, v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "RPNotify:HUDEvent", "time", serverTime)
        CallRemoteEvent(v, "pc:update", serverTime)
    end
end)