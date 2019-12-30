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
		'<span color="#ccc"> Type /tips for some help. </>',	
	}
	
	for i in pairs(tips) do
		CreateTimer(function() 
			AddPlayerChatAll(tips[i])
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
			if police then
				amount = 500
			elseif medic then
				amount = 400
			elseif citizen then
				amount = 150
			elseif delivery then
				amount = 250
			end

			AddBalanceToAccount(v, "cash", amount) 
			balance = PlayerData[v].cash
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

function vc(player, r, g, b)
	if (r == nil or g == nil or b == nil) then
		return AddPlayerChat(player, "Usage: /vc 220 110 55")
	end

	local vehicle = GetPlayerVehicle(player)

	if (vehicle == 0) then
		return AddPlayerChat(player, "You must be in a vehicle")
	end

	if (GetPlayerVehicleSeat(player) ~= 1) then
		return AddPlayerChat(player, "You must be the driver of the vehicle")
	end

	SetVehicleColor(vehicle, RGB(r, g, b))
	AddPlayerChat(player, "New vehicle color applied.")
end
AddCommand("vc", vc)
