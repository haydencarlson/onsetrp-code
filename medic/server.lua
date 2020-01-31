local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local medicNpc = {
            {
                location = { 211664, 159643, 1320, 90 },
                spawn = { 212956, 160465, 1305, -90 }
            },
          
}
local medicPoint = {
    { 116691, 164243, 3028 },
}

local medicNpcCached = {}
local playerMedic = {}
local maxMedics = 10

AddEvent("OnPlayerSpawn", function(player)
    if(GetPlayerPropertyValue(player, "reviveHint") ~= nil) then
	DestroyText3D(GetPlayerPropertyValue(player, "reviveHint"))
	end

	if PlayerData and PlayerData[player] and (PlayerData[player].health_state == "no_medic" or PlayerData[player].health_state == "dead") then
		PlayerData[player].inventory = {}
	end
end)

AddEvent("OnPlayerQuit", function(player)
    if playerMedic[player] ~= nil then
        playerMedic[player] = nil
    end
    if(GetPlayerPropertyValue(player, "reviveHint") ~= nil) then
	DestroyText3D(GetPlayerPropertyValue(player, "reviveHint"))
    end
    if(GetPlayerPropertyValue(player, "medic_on_the_way") ~= nil) then
		local reviver = GetPlayerPropertyValue(player, "medic_on_the_way")
		if(PlayerData[reviver] ~= nil) then
			CallRemoteEvent(reviver, "ClientDestroyCurrentWaypoint")
			CallRemoteEvent(reviver, 'KNotify:Send', _("end_of_emergency"), "#0f0")
		end
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupMedic", medicNpcCached)
end)

AddRemoteEvent("StartMedicJob", function(player)
    local nearestMedic = GetNearestMedic(player)
    if PlayerData[player].job == "" then
	local jobCount = 0
	for k,v in pairs(PlayerData) do
	    if v.job == "medic" then
		jobCount = jobCount + 1
	    end
	end
	if jobCount >= maxMedics then
	    return CallRemoteEvent(player, 'KNotify:Send', _("job_full"), "#f00")
	end
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        else
			local vehicle = CreateVehicle(8, 212758.125, 173967.53125, 1291.8017578125, 180)
			PlayerData[player].job_vehicle = vehicle
			CreateVehicleData(player, vehicle, 8, "EMS")
			SetVehicleRespawnParams(vehicle, false)
			SetVehiclePropertyValue(vehicle, "locked", true, true)
			PlayerData[player].job = "medic"
			CallRemoteEvent(player, 'KNotify:Send', _("join_medic"), "#0f0")
			CallRemoteEvent(player, "UpdateMedicUniform", player)
			UpdateClothes(player)
			return
        end
    end
end)

AddRemoteEvent("StopMedicJob", function(player,spawncar)
    if PlayerData[player].job == "medic" then
		if PlayerData[player].job_vehicle ~= nil then
			DestroyVehicle(PlayerData[player].job_vehicle)
			DestroyVehicleData(PlayerData[player].job_vehicle)
			PlayerData[player].job_vehicle = nil
		end
		PlayerData[player].job = ""
		UpdateClothes(player)
		playerMedic[player] = nil
    end
end)

AddEvent("OnPlayerDeath", function(player)
    PlayerData[player].health_state = "dead"
    local x, y, z = GetPlayerLocation(player)
    PlayerData[player].death_pos[1] = x
    PlayerData[player].death_pos[2] = y
    PlayerData[player].death_pos[3] = z
    SetPlayerPropertyValue(player, "medic_on_the_way", nil, true)

    local medic = false
    for k,v in pairs(GetAllPlayers()) do
	if player ~= v and PlayerData[v].job == "medic" then
	    local reviveHint = CreateText3D(_("revive_player").."\n".._("press_e"), 18, x, y, z + 50, 0, 0, 0)
	    SetPlayerPropertyValue(player, "reviveHint", reviveHint, true)
            SetPlayerRespawnTime(player, 120000)
	    medic = true
	    NotifyConnectedMedics(player)
	    break
        end
    end
    if(medic ~= true) then
	PlayerData[player].health_state = "no_medic"
	CallRemoteEvent(player, 'KNotify:Send', _("no_medic_online"), "#0f0")
    SetPlayerRespawnTime(player, 5000)
	SetPlayerSpawnLocation(player, 212124, 159055, 1305, 90)
    end
end)

function NotifyConnectedMedics(player)
    for k,v in pairs(GetAllPlayers()) do
	if PlayerData[v] == nil then
	    goto continue
	end
	if PlayerData[v].name == nil then
	    goto continue
	end
	if PlayerData[v].steamname == nil then
	    goto continue
	end
	if player == v or PlayerData[v].job ~= "medic" then
	    goto continue
	end
	CallRemoteEvent(v, 'KNotify:Send', _("medic_notification_on_death"), "#0f0")
	::continue::
    end
end

AddRemoteEvent("MedicDoRevive", function(player,deadplayer)
    if player ~= deadplayer and PlayerData[player].job == "medic" then
        SetPlayerAnimation(player, "REVIVE")

	Delay(5000, function()
	    SetPlayerAnimation(player, "STOP")
	    SetPlayerRespawnTime(deadplayer, 100)
	    PlayerData[deadplayer].health_state = "revived"
	    SetPlayerSpawnLocation(deadplayer, PlayerData[deadplayer].death_pos[1], PlayerData[deadplayer].death_pos[2], PlayerData[deadplayer].death_pos[3], 90)
	    CallRemoteEvent(player, 'KNotify:Send', _("revive_player_success"), "#0f0")
		CallRemoteEvent(player, 'KNotify:Send', _("revive_reward"), "#0f0")
		PlayerData[player].bank_balance = PlayerData[player].bank_balance + 200
	    DestroyText3D(GetPlayerPropertyValue(deadplayer, "reviveHint"))
	    if(GetPlayerPropertyValue(deadplayer, "medic_on_the_way") ~= nil) then
			local reviver = GetPlayerPropertyValue(deadplayer, "medic_on_the_way")
			if(PlayerData[reviver] ~= nil) then
				CallRemoteEvent(reviver, "ClientDestroyCurrentWaypoint")
				CallRemoteEvent(reviver, 'KNotify:Send', _("end_of_emergency"), "#0f0")
			end
	    end
	    CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
	    SetPlayerPropertyValue(deadplayer, "medic_on_the_way", nil, true)
	end)
    end
end)

function GetNearestMedic(player)
	local x, y, z = GetPlayerLocation(player)
	
	for k,v in pairs(GetAllNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
			for k,i in pairs(medicNpc) do
				if v == i.npc then
					return k
				end
			end
		end
	end

	return 0
end

AddRemoteEvent("OpenMedicMenu", function(player)
    if PlayerData[player].job == "medic" then
	local x, y, z = GetPlayerLocation(player)
	local playersIds = GetAllPlayers()
	local playersNames = {}

	for k,v in pairs(playersIds) do
	    if PlayerData[k] == nil then
			goto continue
	    end
	    if PlayerData[k].name == nil then
			goto continue
	    end
	    if PlayerData[k].steamname == nil then
			goto continue
	    end
	    if player == k then
			goto continue
	    end

	    if(PlayerData[k].health_state == "dead") then
            if(GetPlayerPropertyValue(k, "medic_on_the_way") == nil) then
                playersNames[tostring(k)] = PlayerData[k].name
            end
	    end

	    ::continue::
	end
	CallRemoteEvent(player, "MedicMenu", playersNames)
    end
end)

AddRemoteEvent("AcceptEmergency", function(player, deadPlayer)
	CallRemoteEvent(deadPlayer, 'KNotify:Send', _("medic_on_their_way"), "#0f0")
	SetPlayerRespawnTime(deadPlayer, 3600000)

	SetPlayerPropertyValue(deadPlayer, "medic_on_the_way", player, true)
	local x, y, z = GetPlayerLocation(deadPlayer)

	CallRemoteEvent(player, "ClientCreateWaypoint", _("emergency"), x, y, z)
	CallRemoteEvent(player, 'KNotify:Send', _("accepted_emergency"), "#0f0")
end)
