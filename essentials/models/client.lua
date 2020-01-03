function OnPackageStart()
	local pakname = "lamboav"
	local res = LoadPak(pakname, "/lamboav/", "essentials/models/lamboav/content/")
	local files = GetAllFilesInPak(pakname)
	AddPlayerChat("Loading of "..pakname..": "..tostring(res))
	AddPlayerChat("Files"..pakname..":"..files)

end
AddEvent("OnPackageStart", OnPackageStart)

