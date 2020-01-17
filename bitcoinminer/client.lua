local Dialog = ImportPackage("dialogui")
BitcoinMinerNpc = nil

AddEvent("OnPackageStart", function()
	LoadPak("gamingcomputer", "/gamingcomputer/", "../../../OnsetModding/Plugins/gamingcomputer/Content")
	ReplaceObjectModelMesh(110, "/gamingcomputer/pc")
end)

AddEvent("OnTranslationReady", function()
    
end)

AddRemoteEvent("SetupBitcoinMinerGuy", function(npc)
    BitcoinMinerNpc = npc
end)

AddRemoteEvent("CreateSoundIn3D", function(filename, x, y, z, radius)
    sound = CreateSound3D(filename, x, y, z, radius)
end)
