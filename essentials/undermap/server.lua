local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local timer = 0
local lastLocations = {}

function teleportUp(player, terrain)

	local x, y, z = GetPlayerLocation(player)
    CallEvent("SafeTeleport", player, x, y, terrain + 200)
    CallRemoteEvent(player, "MakeNotification", _("undermap"), "linear-gradient(to right, #ff5f6d, #ffc371)")
end

AddRemoteEvent("UnderMapFix", teleportUp)

function SafeTeleport(player, x,y,z)
	PauseTimer(timer)
	Delay(10, function()
		lastLocations[player] = {}
		lastLocations[player].x = x
		lastLocations[player].y = y
		lastLocations[player].z = z
		SetPlayerLocation(player, x,y,z)
		Delay(100, function()
			UnpauseTimer(timer)
		end)
	end)	
end
AddEvent("SafeTeleport", SafeTeleport)
