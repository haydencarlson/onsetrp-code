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
AddRemoteEvent("OnPlayerDeath", OnPlayerDeath)

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
 
AddRemoteEvent("EngineOff", function(player)
	local vehicle = GetPlayerVehicle(player)
	StopVehicleEngine(vehicle)
	AddPlayerChat(player, "You turn off your vehicle.")
end)	

function OnPackageStart(player)
	CreateTimer(function(player)
		for _, v in pairs(GetAllPlayers()) do
			local police = PlayerData[v].job == "police" or PlayerData[v].police == "0"
			local medic = PlayerData[v].job == "medic"
			local delivery = PlayerData[v].job == "delivery"
			local robber = PlayerData[v].job == "thief"
			local citizen = PlayerData[v].job == "citizen" or PlayerData[v].job == ""
			local mechanic = PlayerData[v].job == "mechanic"
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
end
AddEvent("OnPackageStart", OnPackageStart)

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