local frozen = {}
local freezeTimer = 0

local function IsCopInRange(x, y, z)
	local playersinrange = GetPlayersInRange3D(x, y, z, 250)
	for key, p in pairs(playersinrange) do
        if PlayerData[p].job == 'police' then
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
	elseif IsCopInRange(x, y, z) then
        CallEvent(instigator, "makeWanted")
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
		'<span color="#FF6800"> Type /g [message] to enter global chat</>',
		'<span color="#FF00F0"> You can use animations, type /dance etc. </>',
		'<span color="#7B061B"> Press U to unlock your vehicle </>',
		'<span color="#B94F00"> Visit restaurants to quench your hunger/thirst </>',
		'<span color="#00B99A"> If you find stuff to harvest, you can sell it! </>',
		'<span color="#3D4EF3"> We are open to suggestions. </>'
	}
	for key, tip in pairs(tips) do
		AddPlayerChat(player, tip)
	end	
end)

local tips = { 
		'<span color="#ccc"> Type /tips for some quick tips. </>',	
	}
	
	for i in pairs(tips) do
		CreateTimer(function() 
			AddPlayerChatAll(tips[i])
	end, 300000)
end

local serverinfo = { 
	'<span color="#ccc"> Type /info to view server information and maybe find some answers. </>',	
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


function SetPlayerOnline(player)
	player = GetPlayerId()
		local query = mariadb_prepare(sql, "SELECT * accounts;")
	  mariadb_query(sql, query)
	  mariadb_async_query(sql, query, OnLoadedData, player)
end
AddEvent("OnPlayerJoin", SetPlayerOnline)

function OnLoadedData(player)
	local entry = mariadb_get_assoc(1)
	local player = FindPlayerByAccountId(entry['accountid'])
	update_query = mariadb_prepare(sql, "UPDATE lotteries SET winner = '?', status = 'closed' WHERE id = '?';",
		"true",	
		tostring(entry['account_id'])
		)
		mariadb_query(sql, update_query)
end