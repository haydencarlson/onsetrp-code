local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

StylistNPCObjectsCached = { }
StylistNPCTable = {
	{
		location = { 211665, 174487, 1307, 90}
		
	}
}

-- Event ----------------------------------------------------

AddEvent("OnPackageStart", function()
	for k,v in pairs(StylistNPCTable) do
		v.npc = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])
		CreateText3D(_("stylist").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)
		table.insert(StylistNPCObjectsCached, v.npc)
	end
end)

AddEvent("OnPlayerJoin", function(player)
	CallRemoteEvent(player, "stylistSetup", StylistNPCObjectsCached)
end)

AddRemoteEvent("stylistInteract", function(player, stylistobject)
    local stylist = GetStylistByObject(stylistobject)
	if stylist then
		CallRemoteEvent(player, "characterize:ShowPanel", false)
	end
end)

function GetStylistByObject(stylistobject)
	for k,v in pairs(StylistNPCObjectsCached) do
		if v == stylistobject then
			return v
		end
	end
	return nil
end
