PlayerBitcoinMiners = {}
AddCommand("miner", function(player)
    local x, y, z = GetPlayerLocation(player)
    newminer = CreateObject(110, x, y, z)
    SetObjectPropertyValue(newminer, "ownerid", PlayerData[player].accountid, true)
    SetObjectPropertyValue(newminer, "mining", true, true)

    --- OnSoundFinished event broken atm cant loop sound
    -- CallRemoteEvent(player, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", x, y, z, 1000)

    PlayerBitcoinMiners[player] = {}
    local newMinerTable = {id = newminer, location = {x=x, y=y, z=z}}
    table.insert(PlayerBitcoinMiners[player], newMinerTable)
end)

CreateTimer(function()
    for k,v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -3092, 141416, 1856, 1000)
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -1997, 141523, 1851, 1000)
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -4089, 141463, 1851, 1000)
    end
end, 7500)