local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end
PlayerData = {}
serverTimeSeconds = 720
function OnPackageStart()
    -- Save all player data automatically
    CreateTimer(function()
		for k, v in pairs(GetAllPlayers()) do
			SavePlayerAccount(v)
		end
		print("All accounts have been saved !")
	end, 30000)
	-- Game time
	CreateTimer(function()
		if serverTimeSeconds + 1 == 1441 then
			serverTimeSeconds = 0
		end
		serverTimeSeconds = serverTimeSeconds + 1
		if serverTimeSeconds % 60 == 0 then
			CallEvent("ServerTime:OneHourPassed")
		end
		CallEvent("ServerTimeUpdated", GetServerTimeString())
	end, 1000)

end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnPackageStop", function()
    for k, v in pairs(GetAllPlayers()) do
        SavePlayerAccount(v)
    end
    print("All accounts have been saved !")
end)


function OnPlayerSteamAuth(player)
    
    CreatePlayerData(player)
    PlayerData[player].steamname = GetPlayerName(player)
    
    AddPlayerChatAll('<span color="#eeeeeeaa">'..GetPlayerName(player)..' from '..PlayerData[player].locale..' joined</>')
	AddPlayerChatAll('<span color="#eeeeeeaa">'..GetPlayerCount()..' players online</>')
	AddPlayerChat(player, '<span color="#ff0000" size="17">Please type /help to view rules, key shortcuts, commands. and server information</>')
    SetPlayerPropertyValue(player, "isWanted", 0, true)
	
    -- First check if there is an account for this player
    local query = mariadb_prepare(sql, "SELECT id FROM accounts WHERE steamid = '?' LIMIT 1;",
        tostring(GetPlayerSteamId(player)))
    
    mariadb_async_query(sql, query, OnAccountLoadId, player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

function OnPlayerQuit(player)
	for k, v in pairs(PlayerData[player].textscreens) do
        if tonumber(tonumber(v['id'])) ~= nil then
			DestroyText3D(tonumber(v['id']))
			table.remove(PlayerData[player].textscreens, k)
		end
	end
	if tonumber(PlayerData[player].hat) ~= 0 then
		DestroyObject(PlayerData[player].hat)
	end
	if PlayerData[player].cigar ~= nil then
		DestroyObject(PlayerData[player].cigar)
	end
	PlayerData[player].logged_in = 0
	SavePlayerAccount(player)
    GatheringCleanPlayerActions(player)-- → Gathering
    DestroyPlayerData(player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnAccountLoadId(player)
    if (mariadb_get_row_count() == 0) then
        --There is no account for this player, continue by checking if their IP was banned
        local query = mariadb_prepare(sql, "SELECT FROM_UNIXTIME(bans.ban_time), bans.reason FROM bans WHERE bans.steamid = ?;",
            tostring(GetPlayerSteamId(player)))
        
        mariadb_async_query(sql, query, OnAccountCheckBan, player)
    else
        --There is an account for this player, continue by checking if it's banned
        PlayerData[player].accountid = mariadb_get_value_index(1, 1)
		local query = mariadb_prepare(sql, "SELECT FROM_UNIXTIME(bans.ban_time), bans.reason FROM bans WHERE bans.steamid = ?;",
			tostring(GetPlayerSteamId(player)))

		mariadb_async_query(sql, query, OnAccountCheckBan, player)
	end
end

function OnAccountCheckBan(player)
	if (mariadb_get_row_count() == 0) then
		--No ban found for this account
		CheckForIPBan(player)
	else
		--There is a ban in the database for this account
		local result = mariadb_get_assoc(1)

		print("Kicking "..GetPlayerName(player).." in the butt! Account banned.")

		KickPlayer(player, _("banned_for", result['reason'], result['FROM_UNIXTIME(bans.ban_time)']))
	end
end

function CheckForIPBan(player)
    local query = mariadb_prepare(sql, "SELECT ipbans.reason FROM ipbans WHERE ipbans.ip = '?' LIMIT 1;",
        GetPlayerIP(player))
    
    mariadb_async_query(sql, query, OnAccountCheckIpBan, player)
end

function OnAccountCheckIpBan(player)
	if (mariadb_get_row_count() == 0) then
		--No IP ban found for this account
		if (PlayerData[player].accountid == 0) then
			CreatePlayerAccount(player)
		else
			LoadPlayerAccount(player)
			LoadPlayerAchievements(player)
		end
	else
		print("Kicking "..GetPlayerName(player).." in the butt! IP banned.")

		local result = mariadb_get_assoc(1)
        
        KickPlayer(player, "🚨 You have been banned from this server.")
	end
end

function CreatePlayerAccount(player)
	local query = mariadb_prepare(sql, "INSERT INTO accounts (id, steamid, clothing, clothing_police, death_pos, inventory, position, police) VALUES (NULL, '?', '[]' , '[]' , '[]', '[]' , '[]', '1');",
		tostring(GetPlayerSteamId(player)))
	mariadb_query(sql, query, OnAccountCreated, player)
end


function OnAccountCreated(player)
	PlayerData[player].accountid = mariadb_get_insert_id()

	CallRemoteEvent(player, "askClientCreation")

	SetPlayerLoggedIn(player)
	setPositionAndSpawn(player, nil)
	CreatePlayerdbAchievements(player)
	print("Account ID "..PlayerData[player].accountid.." created for "..player)

	AddPlayerChat(player, '<span color="#ffff00aa" style="bold italic" size="15">Welcome '..GetPlayerName(player)..'</>')
	AddPlayerChatAll('<span color="00ee00ff">'..PlayerData[player].accountid..' registered players</>')
end

function LoadPlayerAccount(player)
    local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE id = ?;",
        PlayerData[player].accountid)
    
    mariadb_async_query(sql, query, OnAccountLoaded, player)
end

function AddBalanceToAccount(player, account, amount)
	local bank_bal = math.tointeger(PlayerData[player].bank_balance)
	local amount_to_add = amount
	local action = {
		cash = function(amount_to_add, bank_bal) 
			AddPlayerCash(player, amount_to_add)
			CallRemoteEvent(player, "RPNotify:HUDEvent", "cash", GetPlayerCash(player))
		end,
		bank = function(amount_to_add, bank_bal)
			PlayerData[player].bank_balance = bank_bal + amount_to_add
			CallRemoteEvent(player, "RPNotify:HUDEvent", "bank", PlayerData[player].bank_balance)
		end
	}
	action[account](amount_to_add, bank_bal)
end

function GetLoyaltyBalance(player)
	return PlayerData[player].loyalty
end

function RemoveBalanceFromAccount(player, account, amount)
	local bank_bal = PlayerData[player].bank_balance
	local amount_to_remove = amount
	local action = {
		cash = function(player, amount_to_remove, bank_bal) 
			RemovePlayerCash(player, amount_to_remove)
			CallRemoteEvent(player, "RPNotify:HUDEvent", "cash", GetPlayerCash(player))
		end,
		bank = function(player, amount_to_remove, bank_bal)
			PlayerData[player].bank_balance = bank_bal - amount_to_remove
			CallRemoteEvent(player, "RPNotify:HUDEvent", "bank", PlayerData[player].bank_balance)
		end
	}
	action[account](player, amount_to_remove, bank_bal)
end

function RemoveLoyaltyFromAccount(player, account, amount)
	local loyalty_bal = PlayerData[player].loyalty
	local amount_to_remove = amount
	local action = {
		loyalty = function(player, amount_to_remove, loyalty_bal)
			PlayerData[player].loyalty = loyalty_bal - amount_to_remove
		end,
		}	
action[account](player, amount_to_remove, loyalty_bal)
end

function AddLoyaltyFromAccount(player, account, amount)
	local loyalty_bal = PlayerData[player].loyalty
	local amount_to_remove = amount
	local action = {
		loyalty = function(player, amount_to_remove, loyalty_bal)
			PlayerData[player].loyalty = loyalty_bal + amount_to_remove
		end,
		}	
action[account](player, amount_to_remove, loyalty_bal)
end

function OnAccountLoaded(player)
	if (mariadb_get_row_count() == 0) then
		--This case should not happen but still handle it
		KickPlayer(player, "An error occured while loading your account ??")
	else
		local result = mariadb_get_assoc(1)
		PlayerData[player].admin = math.tointeger(result['admin'])
		PlayerData[player].rank_level = math.tointeger(result['rank_level'])
		PlayerData[player].supporter = math.tointeger(result['supporter'])
		PlayerData[player].bank_balance = math.tointeger(result['bank_balance'])
		PlayerData[player].loyalty = math.tointeger(result['loyalty_points'])
		PlayerData[player].name = tostring(result['name'])
		PlayerData[player].clothing = json_decode(result['clothing'])
		PlayerData[player].clothing_police = json_decode(result['clothing_police'])
		PlayerData[player].police = math.tointeger(result['police'])
		PlayerData[player].driver_license = math.tointeger(result['driver_license'])
		PlayerData[player].gun_license = math.tointeger(result['gun_license'])
		PlayerData[player].helicopter_license = math.tointeger(result['helicopter_license'])
		PlayerData[player].inventory = json_decode(result['inventory'])
		PlayerData[player].created = math.tointeger(result['created'])
		PlayerData[player].position = json_decode(result['position'])
		PlayerData[player].time = math.tointeger(result['time'])
		PlayerData[player].kills = math.tointeger(result['kills'])
		PlayerData[player].deaths = math.tointeger(result['deaths'])
		PlayerData[player].hatmodel = math.tointeger(result['hats'])
		PlayerData[player].cigar = nil
		if GetPlayerBag(player) == 1 then
			local x, y, z = GetPlayerLocation(player)
            PlayerData[player].backpack = CreateObject(820, x, y, z)
            SetObjectAttached(PlayerData[player].backpack, ATTACH_PLAYER, player, -30.0, -9.0, 0.0, -90.0, 0.0, 0.0, "spine_03")
		end
		SetPlayerPropertyValue(player, "actionInProgress", 'false', true)
		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armor']))
		setPlayerThirst(player, tonumber(result['thirst']))
		setPlayerHunger(player, tonumber(result['hunger']))
		setPositionAndSpawn(player, PlayerData[player].position)
		SetPlayerLoggedIn(player)
		AchievementSearch(player)
		if math.tointeger(result['created']) == 0 then
			CallRemoteEvent(player, "askClientCreation")
		else
			SetPlayerName(player, PlayerData[player].name)
			UpdateClothes(player)
			-- CallRemoteEvent(player, "AskSpawnMenu")
		end
		if tonumber(IsSupporter(player)) == 1 or tonumber(IsRank(player)) > 0 then
			if tonumber(PlayerData[player].hatmodel) ~= 0 then
				CallEvent("cmd_hat", player, PlayerData[player].hatmodel)
			end
		end
		CallEvent("PlayerDataLoaded", player)
		print("Account ID "..PlayerData[player].accountid.." loaded for "..GetPlayerIP(player))
	end
end

function setPositionAndSpawn(player, position) 
	SetPlayerSpawnLocation(player, 212727.4375, 175845.5, 1309.1500244141, 90)
	if position ~= nil and position.x ~= nil and position.y ~= nil and position.z ~= nil then
		SetPlayerLocation(player, PlayerData[player].position.x, PlayerData[player].position.y, PlayerData[player].position.z + 150) -- Pour empêcher de se retrouver sous la map
	else
		SetPlayerLocation(player, 212727.4375, 175845.5, 1309.1500244141)
		SetPlayerHeading(player, 270)
	end
end

function CreatePlayerData(player)
	PlayerData[player] = {}

	PlayerData[player].accountid = 0
	PlayerData[player].name = ""
	PlayerData[player].clothing = {}
	PlayerData[player].clothing_police = {}
	PlayerData[player].police = 1
	PlayerData[player].medic = 0
	PlayerData[player].inventory = { cash = 1000 }
	PlayerData[player].driver_license = 0
	PlayerData[player].gun_license = 0
	PlayerData[player].helicopter_license = 0
	PlayerData[player].logged_in = false
	PlayerData[player].admin = 0
	PlayerData[player].rank_level = 0
	PlayerData[player].supporter = 0
	PlayerData[player].created = 0
	PlayerData[player].locale = GetPlayerLocale(player)
	PlayerData[player].steamid = GetPlayerSteamId(player)
	PlayerData[player].steamname = ""
	PlayerData[player].thirst = 100
	PlayerData[player].hunger = 100
	PlayerData[player].bank_balance = 900
	PlayerData[player].loyalty = 0
	PlayerData[player].job_vehicle = nil
	PlayerData[player].job = ""
	PlayerData[player].onAction = false
	PlayerData[player].isActioned = false
	PlayerData[player].health_state = "alive"
	PlayerData[player].death_pos = {}
	PlayerData[player].position = {}
	PlayerData[player].lastinteract = ""
	PlayerData[player].play_time = GetTimeSeconds()
	PlayerData[player].time = 0
	PlayerData[player].play_times = GetTimeSeconds()
	PlayerData[player].times = 0
	PlayerData[player].esp_enabled = false
	PlayerData[player].mute = 0
	PlayerData[player].cmd_cooldown = 0
	PlayerData[player].kills = 0
	PlayerData[player].deaths = 0
	PlayerData[player].company = nil
	PlayerData[player].company_upgrades = {}
	PlayerData[player].employee = nil
	PlayerData[player].textscreens = {}
	PlayerData[player].hat = 0
	PlayerData[player].hatmodel = 0
    print("Data created for : "..player)
end

function AddBalanceToBankAccountSQL(accountid, amount)
	if accountid ~= nil and amount ~= nil then
		local update_query = mariadb_prepare(sql, "UPDATE accounts set bank_balance = bank_balance + '?' where id = '?';", amount, accountid)
		print("updating bank balance")
		mariadb_query(sql, update_query)
	end
end

function RemoveBalanceToBankAccountSQL(accountid, amount)
	if accountid ~= nil and amount ~= nil then
		local update_query = mariadb_prepare(sql, "UPDATE accounts set bank_balance = bank_balance - '?' where id = '?';", amount, accountid)
		print("updating bank balance")
		mariadb_query(sql, update_query)
	end
end

function GetServerTimeString()
	hours = string.format("%02.f", math.floor(serverTimeSeconds/3600));
	mins = string.format("%02.f", math.floor(serverTimeSeconds/60 - (hours*60)));
	seconds = string.format("%02.f", math.floor(serverTimeSeconds - hours*3600 - mins *60));
	return mins .. ":" .. seconds
end

function DestroyPlayerData(player)
    if (PlayerData[player] == nil) then
        return
    end
    
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
	end
	
	if PlayerData[player].backpack ~= nil then
		DestroyObject(PlayerData[player].backpack)
		PlayerData[player].backpack = nil
	end

	PlayerData[player] = nil
	print("Data destroyed for : "..player)
end

function FindPlayerByAccountId(accountid)
	if PlayerData[1] ~= nil then
		for key, player in pairs(PlayerData) do
			if tonumber(player['accountid']) == tonumber(accountid) then
				return key
			end
		end
	end
	return false
end

function SavePlayerAccount(player)
	if (PlayerData[player] == nil) then
		return
	end
	if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end
	
	-- Sauvegarde de la position du joueur
	local x, y, z = GetPlayerLocation(player)
	PlayerData[player].position = {x= x, y= y, z= z}
	local query = mariadb_prepare(sql, "UPDATE accounts SET admin = ?, rank_level = ?, supporter = ?, bank_balance = ?, loyalty_points = ?, health = ?, health_state = '?', death_pos = '?', armor = ?, hunger = ?, thirst = ?, name = '?', clothing = '?', clothing_police = '?', hats = '?', inventory = '?', created = '?', position = '?', driver_license = ?, gun_license = ?, helicopter_license = ?, time = ?, kills = ?, deaths = ?, online = ? WHERE id = ? LIMIT 1;",
		PlayerData[player].admin,
		PlayerData[player].rank_level,
		PlayerData[player].supporter,
		PlayerData[player].bank_balance,
		PlayerData[player].loyalty,
		100,
		PlayerData[player].health_state,
		json_encode(PlayerData[player].death_pos),
		GetPlayerArmor(player),
		PlayerData[player].hunger,
		PlayerData[player].thirst,
		PlayerData[player].name,
		json_encode(PlayerData[player].clothing),
		json_encode(PlayerData[player].clothing_police),
		tonumber(PlayerData[player].hatmodel),
		json_encode(PlayerData[player].inventory),
		PlayerData[player].created,
		json_encode(PlayerData[player].position),
		PlayerData[player].driver_license,
		PlayerData[player].gun_license,
		PlayerData[player].helicopter_license,
		GetPlayerTime(player),
		PlayerData[player].kills,
		PlayerData[player].deaths,
		PlayerData[player].logged_in,
		PlayerData[player].accountid
	) 
	mariadb_query(sql, query)
end

function SetPlayerLoggedIn(player)
    PlayerData[player].logged_in = true
end

AddCommand("getrankname", function(player)
	local RankName = GetPlayerRank(player)
	local message = "Your Rank is: "..RankName
	AddPlayerChat(player, message)
end)

function GetPlayerRank(player)
	local RankName = "Player"
	if tonumber(IsRank(player)) < 1 and tonumber(IsSupporter(player)) > 0 then
		RankName = "Supporter"
	elseif IsRank(player) == 1 then
		RankName = "Moderator"
	elseif IsRank(player) == 2 then
		RankName = "Administrator"
	elseif IsRank(player) == 3 then
		RankName = "Community Manager"
	elseif IsRank(player) == 4 then
		RankName = "Owner" 
	end

	if RankName ~= nil then
		return tostring(RankName)
	end

end

function GetRankById(id)
	local RankName = "Player"

	if id == 0 then
		RankName = "player"
	elseif id == 1 then
		RankName = "Moderator"
	elseif id == 2 then
		RankName = "Administrator"
	elseif id == 3 then
		RankName = "Community Manager"
	elseif id == 4 then
		RankName = "Owner" 
	end

	if RankName ~= nil then
		return tostring(RankName)
	end

end

function IsAdmin(player) -- old
    return PlayerData[player].admin == 1
end

function IsSupporter(player)
    return PlayerData[player].supporter
end

function IsRank(player)
    return PlayerData[player].rank_level
end

function SetPlayerBusy(player)-- Shortcut to set a player in a busy state
    local result = SetPlayerPropertyValue(player, "PlayerIsBusy", true, true)
    return result
end
AddRemoteEvent("account:setplayerbusy", SetPlayerBusy)-- To do it clientside

function SetPlayerNotBusy(player)-- Shortcut to set a player in a not busy state
    local result = SetPlayerPropertyValue(player, "PlayerIsBusy", false, true)
    return result
end
AddRemoteEvent("account:setplayernotbusy", SetPlayerNotBusy)-- To do it clientside

function GetPlayerBusy(player)-- Shortcut to get the busy state of the player
    local result = GetPlayerPropertyValue(player, "PlayerIsBusy") or false
    return result
end

-- Exports
AddFunctionExport("isAdmin", IsAdmin) -- old
AddFunctionExport("IsSupporter", IsSupporter)
AddFunctionExport("IsRank", IsRank)
AddFunctionExport("GetPlayerRank", GetPlayerRank)
AddFunctionExport("GetRankById", GetRankById)
AddFunctionExport("FindPlayerByAccountId", FindPlayerByAccountId)
AddFunctionExport("AddBalanceToBankAccountSQL", AddBalanceToBankAccountSQL)
AddFunctionExport("SetPlayerBusy", SetPlayerBusy)
AddFunctionExport("SetPlayerNotBusy", SetPlayerNotBusy)
AddFunctionExport("GetPlayerBusy", GetPlayerBusy)

-- TO REMOVE
function GetPlayerData(player)
    return PlayerData[player]
end
AddFunctionExport("GetPlayerData", GetPlayerData)
