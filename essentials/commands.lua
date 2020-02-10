local textscreen = {}

AddCommand("vehdelete", function(player, vehicle) 
	if tonumber(IsRank(player)) > 0 then
    local vehicle = GetNearestCar(player)
	DestroyVehicle(vehicle)
	AddPlayerChat(player, "Vehicle was removed.")
	end
end)

AddCommand("gp", function(player)
	if tonumber(IsRank(player)) > 0 then
    local x, y, z = GetPlayerLocation(player)
    AddPlayerChat(player, ""..x..", "..y..", "..z)
	print(player, ""..x..", "..y..", "..z)
	end
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
	if tonumber(IsRank(player)) < 1 then
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

function cmd_ban(player, otherplayer, ...)
	if tonumber(IsRank(player)) > 1 then
	local reason = table.concat({...}, " ")
	local message = "You have been banned by ".. GetPlayerName(player) .." \n Reason: ".. reason .." \n Time: ".. os.date('%Y-%m-%d %H:%M:%S', os.time()) ..""
	mariadb_query(sql, "INSERT INTO `bans` (`steamid`, `admin`, `ban_time`, `reason`) VALUES ('"..PlayerData[tonumber(otherplayer)].steamid.."', '"..GetPlayerName(player).."', '"..os.time(os.date('*t')).."', '"..reason.."');")
	KickPlayer(tonumber(otherplayer), message)
	end
end
AddCommand("ban", cmd_ban)

function cmd_kick(player, otherplayer, ...)
	local reason = table.concat({...}, " ")
	local message = "You have been kicked by ".. GetPlayerName(player) .." \n Reason: ".. reason ..""
	if tonumber(IsRank(player)) > 0 then
		KickPlayer(tonumber(otherplayer), message)
	end
end
AddCommand("kick", cmd_kick)

function cmd_unmute(player, otherplayer)
	if tonumber(IsRank(player)) < 1 then
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
	if tonumber(IsRank(player)) < 1 then
		return AddPlayerChat(player, "Insufficient permission")
	end

	if (otherplayer == nil) then
		return AddPlayerChat(player, "Usage: /bring <player>")
	end

	otherplayer = tonumber(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Selected player does not exist")
	end

	local x, y, z = GetPlayerLocation(player)
	SetPlayerLocation(otherplayer, x, y + 50.0, z + 10.0)
	AddPlayerChat(player, "You have teleported "..GetPlayerName(otherplayer))
	AddPlayerChat(otherplayer, "You have been teleported to "..GetPlayerName(player))
end
AddCommand("bring", cmd_get)

function cmd_go(player, otherplayer)
	if (tonumber(IsRank(player)) < 2) then
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
	AddPlayerChat(player, "You have teleported to "..GetPlayerName(otherplayer))
	AddPlayerChat(otherplayer, "You have been teleported to "..GetPlayerName(player))
end
AddCommand("goto", cmd_go)

AddCommand("addtext", function(player, size, height, ...)
    local text = table.concat({...}, " ")
    local x, y, z = GetPlayerLocation(player)     
	if height or size or text ~= nil then
		local amount = 0
		local text_id = CreateText3D(text, size, x, y, z + height, 0,0,0)
		table.insert(PlayerData[player].textscreens, { id = text_id, text= text })
	end  
end)

local function DeleteTextscreen(player, id) 
    for k, v in pairs(PlayerData[player].textscreens) do
        if tonumber(v['id']) == tonumber(id) then
			DestroyText3D(tonumber(v['id']))
			table.remove(PlayerData[player].textscreens, k)
		end
    end
end
AddCommand("showtext", function(player)
	for k, v in pairs(PlayerData[player].textscreens) do
        if tonumber(v['id']) ~= nil then
			AddPlayerChat(player, "ID: ".. v['id'] .. " Content: ".. v['text'] .."")
		end
	end
end)

AddCommand("removetext", function(player, id)
	if id ~= nil then
	DeleteTextscreen(player, id)
	end
	if id == nil then
		AddPlayerChat(player, "Usage: /removetext [ID]")
		AddPlayerChat(player, "Example: /removetext 411 - PS: Use /showtext to display all of your text screens.")
	end
end)

AddCommand("loyalty", function(player, instigator)
	if tonumber(IsRank(player)) > 2 then
		local balance = GetLoyaltyBalance(tonumber(instigator))
		AddPlayerChat(player, "".. GetPlayerName(tonumber(instigator)) .." has ".. balance .." loyalty points.")
	else
		AddPlayerChat(player, "Insufficient permissions.")
	end
end)


AddCommand("buysupporter", function(player, instigator)
	if instigator ~= nil then
		if tonumber(IsSupporter(tonumber(instigator))) == 0 then
			if GetLoyaltyBalance(tonumber(player)) > 500 then
				PlayerData[player].loyalty = PlayerData[player].loyalty - 500
				if tonumber(player) == tonumber(instigator) then
					CallRemoteEvent(player, 'KNotify:Send', "You have bought supporter status.", "#0f0")
					AddPlayerChatAll('<span color="#800000">'.. GetPlayerName(player) ..' is now a supporter!</>')
					PlayerData[player].supporter = 1
				else
					CallRemoteEvent(player, 'KNotify:Send', "You have bought supporter status for ".. GetPlayerName(instigator) ..". \nYou have ".. GetLoyaltyBalance(tonumber(player)) .." loyalty points left.", "#0f0")
					PlayerData[instigator].supporter = 1
					AddPlayerChatAll('<span color="#800000">'.. GetPlayerName(player) ..' has bought supporter rank for '.. GetPlayerName(instigator) ..'!</>')
				end
			else
				CallRemoteEvent(player, 'KNotify:Send', "You dont have enough for that.", "#f00")
			end
		else
			CallRemoteEvent(player, 'KNotify:Send', "This player is already a supporter.", "#f00")
		end
	else
		AddPlayerChat(player, "Usage: /buysupporter [playerid] \nExample: /buysupporter 1")
	end
end)

AddCommand("buynamechange", function(player, ...)
local name = table.concat({...}, " ")
	if name ~= nil and string.len(name) < 21 then
		if name ~= PlayerData[player].name then	
			if GetLoyaltyBalance(tonumber(player)) > 150 then
				PlayerData[player].loyalty = PlayerData[player].loyalty - 150
				PlayerData[player].name = name
				AddPlayerChat(player, '<span color="#800000">Your name is now '.. PlayerData[player].name ..'!</>')
				AddPlayerChat(player, '<span color="#600000">You make need to reconnect to see the changes.</>')
				CallRemoteEvent(player, "RPNotify:HUDEvent", "name", PlayerData[player].name)
				--CallRemoteEvent(player, "RequestScoreboardUpdate")
			else
				CallRemoteEvent(player, 'KNotify:Send', "You dont have enough for that.", "#f00")
			end
		else
			CallRemoteEvent(player, 'KNotify:Send', "You already have that name.", "#f00")
		end
	else
		AddPlayerChat(player, "Usage:/buynamechange [Name] Max 20 characters long. \nExample: John Smith")
	end
end)	