local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local stylistNPC
local stylistNPCIds = { }

AddEvent("OnKeyPress", function(key)
    if key == INTERACT_KEY and not GetPlayerBusy() then
        local NeareststylistNPC = GetNeareststylistNPC()
		if NeareststylistNPC ~= 0 then
			CallRemoteEvent("stylistInteract", NeareststylistNPC)
		end
	end
end)

AddRemoteEvent("stylistSetup", function(stylistObjects)
	stylistNPCIds = stylistObjects
end)

function GetNeareststylistNPC()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150.0 then
			for k,i in pairs(stylistNPCIds) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end
