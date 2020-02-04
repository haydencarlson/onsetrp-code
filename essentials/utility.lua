local frozen = {}
local freezeTimer = 0

local function IsCopInRange(player, x, y, z)
	local playersinrange = GetPlayersInRange3D(x, y, z, 250)
	for key, p in pairs(playersinrange) do
        if PlayerData[p].job == 'police' and p ~= player then
			return true
        end
    end
    return false
end

function OnPlayerDeath(player, instigator)
    message = '<span color="#9B0700">You were killed by '..GetPlayerName(instigator)..'</>'
    death = '<span color="#9B0700">You played yourself!</> '
    local x, y, z = GetPlayerLocation(instigator)
	if player == instigator then 
		AddPlayerChat(player,  death)
	elseif IsCopInRange(player, x, y, z) then
        CallEvent("makeWanted", instigator)
    else
        AddPlayerChat(player,  message)
    end
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

AddCommand("tips", function(player)
	local tips = {
		'<span color="#575757"> Press F3 when you have a job to access your job menu </>',
		'<span color="#CBD800"> Press F4 to view your inventory </>',
		'<span color="#00E307"> Press F1 near your vehicle for options </>',
		'<span color="#00DCE3"> Press G for GPS </>',
		'<span color="#D100FF"> Respect each others gameplay. </>',
		'<span color="#FF6800"> Type /g [message] to send a message in global</>',
		'<span color="#FF00F0"> You can use animations push F2 </>',
		'<span color="#7B061B"> Press U to unlock your vehicle </>',
		'<span color="#B94F00"> Visit restaurants/shops to quench your hunger/thirst </>',
		'<span color="#00B99A"> If you find stuff to harvest, you can sell it! </>',
		'<span color="#3D4EF3"> We are open to suggestions. </>'
	}
	for key, tip in pairs(tips) do
		AddPlayerChat(player, tip)
	end	
end)

local tips = { 
		'<span color="#ccc"> Type /tips for some quick tips. </>',
		'<span color="#ff0000">Discord: https://discord.balancerp.com Website: https://balancerp.com</>'
	}
	
	for i in pairs(tips) do
		CreateTimer(function() 
			AddPlayerChatAll(tips[i])
	end, 300000)
end

local serverinfo = { 
	'<span color="#ccc"> Please type /help to view rules, key shortcuts, commands. and server information </>',	
}

for i in pairs(serverinfo) do
	CreateTimer(function() 
		AddPlayerChatAll(serverinfo[i])
	end, 300000)
end

function OnPackageStart(player)
	CreateTimer(function(player)
		for _, v in pairs(GetAllPlayers()) do
			local police = PlayerData[v].job == "police" or PlayerData[v].police == "0"
			local medic = PlayerData[v].job == "medic"
			local delivery = PlayerData[v].job == "delivery"
			local robber = PlayerData[v].job == "thief"
			local citizen = PlayerData[v].job == "citizen" or PlayerData[v].job == ""
			local mechanic = PlayerData[v].job == "mechanic"
			local cinema = PlayerData[v].job == "cinema"
			local mayor = PlayerData[v].job == "mayor"
			if police then
				amount = 1000
			elseif medic then
				amount = 600
			elseif citizen then
				amount = 150
			elseif delivery then
				amount = 500
			elseif mechanic then
				amount = 700
			elseif cinema then
				amount = 350
			elseif mayor then
				amount = 1200
			end

			AddBalanceToAccount(v, "cash", amount) 
			balance = GetPlayerCash(v)
			message = '<span color="#00B159">You received a paycheck of </>$' ..amount
			welfare = '<span color="#00B159">You received a welfare check of </>$' ..amount
			newbal = '<span color="#00B159">Your new balance is</> $' ..balance
			criminal = 'You did not get a paycheck because you are a criminal.'

			if citizen then
				AddPlayerChat(v, welfare)
				AddPlayerChat(v, newbal)
			elseif police or medic or delivery then
				AddPlayerChat(v, message)
				AddPlayerChat(v, newbal)
			elseif thief then
				AddPlayerChat(v, criminal)
			end		
		end
	end, 600000, v)

	CreateTimer(function(player)
		for k, v in pairs (GetAllPlayers()) do
			if PlayerData[v] ~= nil and PlayerData[v].accountid ~= nil then
				local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE id = '?';",
				PlayerData[v].accountid)
				mariadb_async_query(sql, query, GetPlayerTime, v)
			end
		end 
	end, 1000, player)

end
AddEvent("OnPackageStart", OnPackageStart)

AddCommand("freeze", function(player, instigator)
	if tonumber(PlayerData[player].admin) == 1 and IsValidPlayer(instigator) then
		local adminname = GetPlayerName(player)
		local playername = GetPlayerName(instigator)
		local afmsg = "You have frozen: "..playername..""	
		local freezemsg = "You have been frozen by: "..adminname..""
		local _x, _y, _z = GetPlayerLocation(instigator)

		CallRemoteEvent(instigator, 'KNotify:Send', freezemsg, "#f00")
		CallRemoteEvent(player, 'KNotify:Send', afmsg, "#0f0")
    	HandcuffPlayer(instigator, instigator, _x, _y, _z)
		CallRemoteEvent(instigator, "LockControlMove", true)
		else
			AddPlayerChat(player, "Enter a valid player ID")
			return false
		end
end)

AddCommand("unfreeze", function(player, instigator)
	if tonumber(PlayerData[player].admin) == 1 and IsValidPlayer(instigator) then
		local adminname = GetPlayerName(player)
		local unfreezemsg = "You have been unfrozen by: "..adminname..""
		local playername = GetPlayerName(instigator)
		local aufmsg = "You have unfrozen: "..playername..""

        FreeHandcuffPlayer(instigator)
        CallRemoteEvent(instigator, "LockControlMove", false)
		CallRemoteEvent(instigator, 'KNotify:Send', unfreezemsg, "#f00")
		CallRemoteEvent(player, 'KNotify:Send', aufmsg, "#0f0")
		else
			AddPlayerChat(player, "Enter a valid player ID")
			return false
      	end
end)

function GetCurrentPlayTime(player)
	CreateTimer(function(player)
		for k, v in pairs (GetAllPlayers()) do
			if GetAllPlayers() == true then
				local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE id = '?' LIMIT 1;",
				PlayerData[v].accountid)
				mariadb_async_query(sql, query, GetPlayerTime, v)
			end
		end 
	end, 1000, player)
end
AddEvent("OnPackageStart", GetCurrentPlayTime)

function GetPlayerTime(player)
	local result = mariadb_get_assoc(1)
	local playtime = math.tointeger(result['time']) -- total time played on the server
	PlayerData[player].time = math.floor(PlayerData[player].time + (GetTimeSeconds() - PlayerData[player].play_time))
	PlayerData[player].play_time = GetTimeSeconds()
	return PlayerData[player].time + playtime -- returns current session play time + total play time on the server
end

function FormatUpTime(seconds)
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

AddCommand("uptime", function(player)
	if GetTimeSeconds() > 3600 then
		AddPlayerChat(player, "The server has been up for "..FormatUpTime(GetTimeSeconds()).." hours.")
	elseif GetTimeSeconds() > 60 then
		AddPlayerChat(player, "The server has been up for "..FormatUpTime(GetTimeSeconds()).." minutes.")
	else
		AddPlayerChat(player, "The server has been up for "..FormatUpTime(GetTimeSeconds()).." seconds.")
	end
end)

function GetPlayerKD(player)
	local deaths = PlayerData[player].deaths
	if deaths == 0 then
		deaths = 1.0
	end

	return string.format("%.2f", PlayerData[player].kills / deaths)
end

function OnPlayerDeath(player, instigator)
	PlayerData[player].deaths = PlayerData[player].deaths + 1

	if (player ~= instigator) then
		PlayerData[instigator].kills = PlayerData[instigator].kills + 1
	end
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

function cmd_pm(player, otherplayer, ...)
	local message = table.concat({...}, " ") 

	if (otherplayer == nil or #{...} == 0) then
		return AddPlayerChat(player, "Usage: /pm <player> <message>")
	end

	otherplayer = tonumber(otherplayer)

	if (not IsValidPlayer(otherplayer)) then
		return AddPlayerChat(player, "Unknown player")
	end
	
	if (player == otherplayer) then
		return AddPlayerChat(player, "Cannot do this command on yourself")
	end
	
	AddPlayerChat(otherplayer, "***[PM] from Player("..player.."): "..message)
	AddPlayerChat(player, ">>>[PM] to Player("..otherplayer.."): "..message)
end
AddCommand("pm", cmd_pm)

function cmd_richestplayer(player)
	local arr = {}
	for _, v in pairs(GetAllPlayers()) do
		table.insert(arr, { PlayerData[v].cash, v })
	end

	table.sort(arr, function(a, b)
		return a[1] > b[1]
	end)

	for k, v in pairs(arr) do
		local cash = GetPlayerCash(v[2])
		local bank = PlayerData[v[2]].bank_balance
		local total = bank + cash
		AddPlayerChat(v[2], ''..GetPlayerName(v[2])..' is the richest player and has $'..total..'')
	end
end
AddCommand("richestplayer", cmd_richestplayer)

function cmd_oldestplayer(player)
	local arr = {}
	for _, v in pairs(GetAllPlayers()) do
		table.insert(arr, { PlayerData[v].time, v })
	end

	table.sort(arr, function(a, b)
		return a[1] > b[1]
	end)

	for k, v in pairs(arr) do
		local time = v[1]
		if time > 3600 then
			local message = ""..GetPlayerName(v[2]).." is the oldest player and has played "..FormatPlayTime(v[1]).." hours"
			AddPlayerChat(v[2], message)
		elseif time < 3600 then
		local message = ""..GetPlayerName(v[2]).." is the oldest player and has played "..FormatPlayTime(v[1]).." minutes"
		AddPlayerChat(v[2], message)
		end
	end
end
AddCommand("oldestplayer", cmd_oldestplayer)


function cmd_kdr(player)
	local message = "Your KDR is %"..GetPlayerKD(player)..""
	AddPlayerChat(player, message)
end
AddCommand("kdr", cmd_kdr)

--[[
function SetPlayerOnline(player)
		local query = mariadb_prepare(sql, "UPDATE accounts SET online = '?' WHERE steamid = '?';",
		"true",	
		tostring(PlayerData[player].steamid)
		)
	  mariadb_query(sql, query)
	  print(PlayerData[player].steamid)
end
AddEvent("OnPlayerSteamAuth", SetPlayerOnline)

function SetPlayerOffline(player)
	local player = FindPlayerByAccountId(PlayerData[player].accountid)
	local query = mariadb_prepare(sql, "UPDATE accounts SET online = '?' WHERE id = '?';",
	"false",	
	tostring(player)
	)
  mariadb_query(sql, query)
  print(player)
end
AddEvent("OnPlayerQuit", SetPlayerOffline)]]