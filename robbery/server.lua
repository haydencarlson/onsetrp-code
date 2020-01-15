local kes = ImportPackage('kuz_Essentials')

local Stores = Config.Stores

local InProgress = {}
local recentDeductionTimer = 0




function OnPackageStart()
	local i = 1
	for _ in pairs(Stores) do
		local obj = CreatePickup(336, Stores[i].x, Stores[i].y, Stores[i].z - 100)
		SetPickupScale(obj, 0.8,0.8,0.5)
		SetPickupPropertyValue(obj, 'type', 'robbery', true)
		SetPickupPropertyValue(obj, 'robbery_id', i, true)
		SetPickupPropertyValue(obj, "color", "a61414", true)
		i = i + 1
	end
	recentDeductionTimer = CreateTimer(deduceRecent, 5000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPlayerQuit(player)
	InProgress[player] = nil
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnRobberyLaunch(player, robbery_id)
	local x,y,z = GetPlayerLocation(player)
	if PlayerData[player].job ~= 'thief' then
		return CallRemoteEvent(player, 'KNotify:Send', "You arent a Thief", "#f00")
	end
	local copsOnline = 0
	for _, v in pairs(GetAllPlayers()) do
		local job = PlayerData[v].job
		if job == "police" then
			copsOnline = copsOnline + 1
		end
	end

	if Stores[robbery_id].recent <= 0 then
		if Stores[robbery_id].min_cops <= copsOnline then
			if GetPlayerEquippedWeapon(player) ~= 0 then
				if GetDistance3D(x,y,z, Stores[robbery_id].x, Stores[robbery_id].y, Stores[robbery_id].z) <= 126 and InProgress[player] == nil then
					CallRemoteEvent(player, "Kuzkay:RobberiesConfirmStart")
					InProgress[player] = {}
					InProgress[player].checks = 0
					InProgress[player].timer = CreateTimer(CheckRobbery, (tonumber(Stores[robbery_id].duration) * 1000) / 10, player, robbery_id)
					CallRemoteEvent(player, 'KNotify:Send', "Robbery has started, don't go too far away", "#0f0")
					CallRemoteEvent(player, 'KNotify:AddProgressBar', "STORE ROBBERY", tonumber(Stores[robbery_id].duration), "#990000", "store_robbery", true)
					for _, v in pairs(GetAllPlayers()) do
						local job = PlayerData[v].job
						if job == "police" then
							CallRemoteEvent(v, 'KNotify:AddProgressBar', "ROBBERY AT " .. Stores[robbery_id].name , 30, "#2e45db", "robbery_" .. math.random(-99999,99999), true)
						end
					end
					CallEvent("Kuzkay:PhoneSendToJob", "police", "Robbery at " .. Stores[robbery_id].name .." !", Stores[robbery_id].x, Stores[robbery_id].y, Stores[robbery_id].z)
				end
			else
				CallRemoteEvent(player, 'KNotify:Send', "You don't pose a threat to this store (get a weapon)", "#f00")
			end
		else
			CallRemoteEvent(player, 'KNotify:Send', "There's not enough cops online to rob this place (needs at least " .. Stores[robbery_id].min_cops ..")", "#f00")
		end
	else
		CallRemoteEvent(player, 'KNotify:Send', "This location was robbed too recently", "#f00")
	end
end
AddRemoteEvent("Kuzkay:RobberiesLaunch", OnRobberyLaunch)

function CheckRobbery(player, robbery_id)
	if IsValidPlayer(player) and InProgress[player] ~= nil then
		local x,y,z = GetPlayerLocation(player)
		if GetDistance3D(x,y,z, Stores[robbery_id].x, Stores[robbery_id].y, Stores[robbery_id].z) <= 600 and not GetPlayerPropertyValue(player, 'dead') and not IsPlayerDead(player) then
			if InProgress[player].checks >= 10 then
				FinishRobbery(player, robbery_id)
			else
				InProgress[player].checks = InProgress[player].checks + 1			
			end
		else
			CancelRobbery(player, robbery_id)
		end
	else
		CancelRobbery(player, robbery_id)
	end
end

function CancelRobbery(player, robbery_id)
	if IsValidTimer(InProgress[player].timer) then
		DestroyTimer(InProgress[player].timer)
		Stores[robbery_id].recent = Stores[robbery_id].cooldown
		CallRemoteEvent(player, 'KNotify:Send', "Robbery has been cancelled, you went too far away", "#f00")
		CallRemoteEvent(player, 'KNotify:SetProgressBarText', "store_robbery", "YOU WENT TOO FAR, ROBBERY CANCELLED")
		InProgress[player] = nil
		CallRemoteEvent(player, 'Kuzkay:RobberiesStop')

		Delay(2000, function()
			CallRemoteEvent(player, 'KNotify:RemoveProgressBar', "store_robbery")
		end)
	end
end

function FinishRobbery(player, robbery_id)
	if IsValidTimer(InProgress[player].timer) then
		Stores[robbery_id].recent = Stores[robbery_id].cooldown
		local payout = math.random(Stores[robbery_id].payout_min, Stores[robbery_id].payout_max)
		DestroyTimer(InProgress[player].timer)
		AddBalanceToAccount(player, "cash", payout)
		CallEvent("makeWanted", player)
		CallRemoteEvent(player, 'KNotify:SetProgressBarText', "store_robbery", "You stole $" .. payout)
		CallRemoteEvent(player, 'KNotify:Send', "Robbery finished, you stole $" .. payout, "#0f0")
		CallRemoteEvent(player, 'Kuzkay:RobberiesStop')
		InProgress[player] = nil
	end
end

function deduceRecent()
	local i = 1
	for _ in pairs(Stores) do
		if Stores[i].recent ~= nil then
			if Stores[i].recent > 0 then
				Stores[i].recent = Stores[i].recent - 5
			end
		end
		i = i + 1
	end
end