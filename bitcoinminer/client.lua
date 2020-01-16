-- LoopSounds = {}
AddEvent("OnPackageStart", function()
    local pakname = "gamingcomputer"
	local res = LoadPak(pakname, "/gamingcomputer/", "../../../OnsetModding/Plugins/gamingcomputer/Content")
	res = ReplaceObjectModelMesh(110, "/gamingcomputer/pc")
end)


-- AddRemoteEvent("CreateSoundIn3D", function(filename, x, y, z, radius)
--     sound = CreateSound3D(filename, x, y, z, radius)
--     LoopSounds[sound] = true
-- end)

-- AddEvent("OnSoundFinished", function(sound)
--     AddPlayerChat("here")
-- end)