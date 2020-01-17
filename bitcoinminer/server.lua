local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
PlayerBitcoinMiners = {}
BitcoinMinerNpcXYZ = { -1414, 141106, 1851}
BitcoinMinerNpc = nil
AddEvent("OnPackageStart", function()
    CreateText3D("Bitcoin Manager".."\n".._("press_e"), 18, BitcoinMinerNpcXYZ[1], BitcoinMinerNpcXYZ[2], BitcoinMinerNpcXYZ[3] + 120, 0, 0, 0)
    BitcoinMinerNpc = CreateNPC(BitcoinMinerNpcXYZ[1], BitcoinMinerNpcXYZ[2], BitcoinMinerNpcXYZ[3], 180)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupBitcoinMinerGuy", BitcoinMinerNpc)
end)

CreateTimer(function()
    for k,v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -3092, 141416, 1856, 1000)
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -1997, 141523, 1851, 1000)
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -4089, 141463, 1851, 1000)
    end
end, 7500)