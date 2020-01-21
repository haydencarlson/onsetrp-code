AddCommand("vehdelete", function(player, vehicle) 
if tonumber (PlayerData[player].admin) == 1 then
     local vehicle = GetNearestCar(player)
	DestroyVehicle(vehicle)
		end
end)

AddCommand("gp", function(player)
    local x, y, z = GetPlayerLocation(player)
    AddPlayerChat(player, ""..x..", "..y..", "..z)
    print(player, ""..x..", "..y..", "..z)
end)


AddCommand("advert", function(player, ...)
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[i]
    end
    message = '<span color="#ebc034">[Advert] '..GetPlayerName(player)..':</> '..message
    AddPlayerChatAll(message)
end)

function AddAdminChat(message)
	for _, v in pairs(GetAllPlayers()) do
		if (PlayerData[v].admin > 0) then
			AddPlayerChat(v, '<span color="#00FF80">[ADMIN CHAT] '..message..'</>')
		end
	end
end

function FormatPlayTime(seconds)
	local seconds = tonumber(seconds)
  
	if seconds <= 0 then
		return "00:00:00"
	else
		hours = string.format("%02.f", math.floor(seconds / 3600));
		mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
		secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
		return hours..":"..mins..":"..secs
	end
end

function cmd_mute(player, otherplayer, seconds, reason)
	if (PlayerData[player].admin < 0) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	if (otherplayer == nil or seconds == nil or reason == nil) then
		return AddPlayerChat(player, "Usage: /mute <player> <seconds> <reason>")
	end

	otherplayer = tonumber(otherplayer)
	seconds = tonumber(seconds)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	if (seconds < 0 or seconds > 10000) then
		return AddPlayerChat(player, "Parameter \"seconds\" 0-10000")
	end

	if (#reason < 4 or #reason > 128) then
		return AddPlayerChat(player, "Parameter \"reason\" invalid length 4-128")
	end

	PlayerData[otherplayer].mute = GetTimeSeconds() + seconds

	AddPlayerChatAll(GetPlayerName(otherplayer).."("..otherplayer..") has been muted by Admin "..GetPlayerName(player).."("..player..") for "..seconds.." seconds (Reason: "..reason..")")
end
AddCommand("mute", cmd_mute)

function cmd_unmute(player, otherplayer)
	if (PlayerData[player].admin < 0) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	if (otherplayer == nil) then
		return AddPlayerChat(player, "Usage: /unmute <player>")
	end

	otherplayer = tonumber(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	if (PlayerData[otherplayer].mute == 0) then
		return AddPlayerChat(otherplayer, "Selected player is not muted")
	else
		if (CheckForUnmute(otherplayer)) then
			return AddPlayerChat(otherplayer, "Selected player is not muted")
		end
	end

	PlayerData[otherplayer].mute = 0

	AddPlayerChat(otherplayer, "You have been unmuted by an Admin")
	AddPlayerChat(player, "Player has been umuted")
end
AddCommand("unmute", cmd_unmute)

function cmd_get(player, otherplayer)
	if (PlayerData[player].admin < 0) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	if (otherplayer == nil) then
		return AddPlayerChat(player, "Usage: /get <player>")
	end

	otherplayer = tonumber(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	local x, y, z = GetPlayerLocation(player)
	SetPlayerLocation(otherplayer, x, y + 50.0, z + 10.0)
	AddPlayerChat(otherplayer, "You have been teleported to "..GetPlayerName(player))
end
AddCommand("bring", cmd_get)

function cmd_go(player, otherplayer)
	if (PlayerData[player].admin < 0) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	if (otherplayer == nil) then
		return AddPlayerChat(player, "Usage: /go <player>")
	end

	otherplayer = tonumber(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	local x, y, z = GetPlayerLocation(otherplayer)
	SetPlayerLocation(player, x, y, z + 50.0 + 10.0)	
	AddPlayerChat(player, "You have teleported to "..GetPlayerName(player))
end
AddCommand("goto", cmd_go)

function cmd_esp(player)
	if (PlayerData[player].admin < 0) then
		return AddPlayerChat(player, "Insufficient permission")
	end

	PlayerData[player].esp_enabled = not PlayerData[player].esp_enabled

	local enable = 0
	if (PlayerData[player].esp_enabled) then
		enable = 1
	end
	CallRemoteEvent(player, "SetEnableESP", enable)

	AddPlayerChat(player, "ESP: "..tostring(PlayerData[player].esp_enabled))
end
AddCommand("esp", cmd_esp)