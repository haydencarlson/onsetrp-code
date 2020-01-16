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