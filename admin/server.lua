local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local teleportPlace = {
    gas_station = { 125773, 80246, 1645 },
    town = { -182821, -41675, 1160 },
    prison = { -167958, 78089, 1569 },
    diner = { 212405, 94489, 1340 },
    shopp1 = { 128000, 77622, 1576 },
    shopp2 = { 42600, 137926, 1581 },
    shopp3 = { -15300, -2773, 2065 },
    cockinbell = { 194206, 177201, 1307 },
    bar = { 49100, 133316, 1578 },
    shopp4 = { -169000, -39441, 1149 },
    weed_gather_zone = { 186601, -39031, 1451 },
    weed_process_zone = { 70695, 9566, 1366 },
    heroin_gather_zone = { 186474, -43277, 1451 },
    heroin_process_zone = { 73218, 3822, 1367 },
    meth_gather_zone = { 192892, -48217, 1444 },
    meth_process_zone = { 193607, -46512, 1451 },
    wealthbank = { 211925, 191382, 1306 },
    coke_gather_zone = { 192080, -45155, 1529 },
    coke_process_zone = { 71981, 106, 1367 },
    mining_gather_zone = { 32853, 98521, 1849 },
    mining_process_zone = { 2427, 98041, 1497 },
    mining_sell_zone = { 21799, 137848, 1555 },
    drugs_sell_zone = { -177344, 3673, 1992 },
    home_cardealer = { 161069, 191846, 1322 },
    train_station = { 134704, 209961, 1292 },
    old_cardealer = { 127720, 80774, 1567 },
    delivery_npc_location = { -16925, -29058, 2200 },
    license_shop = { 183339, 182525, 1291 },
    city_hall = {211882, 175167, 1307}
}


local weaponList = {
    weapon_2 = 2,
    weapon_3 = 3,
    weapon_4 = 4,
    weapon_5 = 5,
    weapon_6 = 6,
    weapon_7 = 7,
    weapon_8 = 8,
    weapon_9 = 9,
    weapon_10 = 10,
    weapon_11 = 11,
    weapon_12 = 12,
    weapon_13 = 13,
    weapon_14 = 14,
    weapon_15 = 15,
    weapon_16 = 16,
    weapon_17 = 17,
    weapon_18 = 18,
    weapon_19 = 19,
    weapon_20 = 20,
}

local vehicleList = {
    vehicle_1 = 1,
    vehicle_2 = 2,
    vehicle_3 = 3,
    vehicle_4 = 4,
    vehicle_5 = 5,
    vehicle_6 = 6,
    vehicle_7 = 7,
    vehicle_8 = 8,
    vehicle_9 = 9,
    vehicle_10 = 10,
    vehicle_11 = 11,
    vehicle_12 = 12,
    vehicle_13 = 13,
    vehicle_14 = 14,
    vehicle_15 = 15,
    vehicle_16 = 16,
    vehicle_17 = 17,
    vehicle_18 = 18,
    vehicle_19 = 19,
    vehicle_20 = 20,
    vehicle_21 = 21,
    vehicle_22 = 22,
    vehicle_23 = 23,
    vehicle_24 = 24,
    vehicle_25 = 25,
    vehicle_26 = 10
}

AddRemoteEvent("ServerAdminMenu", function(player)
    local playersIds = GetAllPlayers()

    if tonumber(IsRank(player)) > 1 then
        playersNames = {}
        for k,v in pairs(playersIds) do
            if PlayerData[v] ~= nil and PlayerData[v].name ~= nil and PlayerData[v].steamname ~= nil then
                playersNames[tostring(v)] = PlayerData[v].name.." ["..PlayerData[v].steamname.."]"
                ::continue::
            end
            CallRemoteEvent(player, "OpenAdminMenu", teleportPlace, playersNames, weaponList, vehicleList)
        end
    end
end)


AddCommand("setrank", function(player, target, rankid)
    if tonumber(IsRank(player)) > 2 then
    PlayerData[tonumber(target)].rank = tonumber(rankid)
    AddPlayerChat(target, '<span color="#ff0000">'.. GetPlayerName(player) ..' Has made you a '.. GetRankById(tonumber(rankid)) ..' </>')
    end
end)

AddCommand("jail", function(player, target)
    if tonumber(IsRank(player)) > 0 then
        SetPlayerLocation(target, -175307.578125, 83121.9921875, 2000.1500244141)
    end
end)

AddCommand("unjail", function(player, target)
    if tonumber(IsRank(player)) > 0 then
        SetPlayerLocation(target, 212727.4375, 175845.5, 1500.1500244141)
    end
end)

AddRemoteEvent("AdminTeleportToPlace", function(player, place)
    if tonumber(IsRank(player)) > 1 then return end
    for k,v in pairs(teleportPlace) do
        if k == place then
            SetPlayerLocation(player, v[1], v[2], v[3] + 200)
        end
    end
end)

AddRemoteEvent("AdminTeleportToPlayer", function(player, toPlayer)
    local x, y, z  = GetPlayerLocation(tonumber(toPlayer))
    SetPlayerLocation(player, x, y, z + 200)
end)

AddRemoteEvent("AdminTeleportPlayer", function(toPlayer, player)
    if tonumber(IsRank(player)) > 1 then return end
    local x, y, z  = GetPlayerLocation(tonumber(toPlayer))
    SetPlayerLocation(player, x, y, z + 200)
end)

AddRemoteEvent("AdminGiveWeapon", function(player, weaponName)
    if tonumber(IsRank(player)) > 3 then
    weapon = weaponName:gsub("weapon_", "")
    SetPlayerWeapon(player, tonumber(weapon), 1000, true, 1, true)
    end
end)

AddRemoteEvent("AdminSpawnVehicle", function(player, vehicleName)
    if tonumber(IsRank(player)) > 3 then
    vehicle = vehicleName:gsub("vehicle_", "")

    local x, y, z = GetPlayerLocation(player)
    local h = GetPlayerHeading(player)

    spawnedVehicle = CreateVehicle(tonumber(vehicle), x, y, z, h)

    SetVehicleRespawnParams(spawnedVehicle, false)
    SetPlayerInVehicle(player, spawnedVehicle)
    end
end)

AddRemoteEvent("AdminGiveMoney", function(player, toPlayer, account, amount)
    if tonumber(IsRank(player)) > 3 then 
        if account == "Cash" then
            AddBalanceToAccount(tonumber(toPlayer), 'cash', amount)
        end
        if account == "Bank" then
            PlayerData[tonumber(toPlayer)].bank_balance = PlayerData[tonumber(toPlayer)].bank_balance + tonumber(amount)
        end
    end
end)

AddRemoteEvent("AdminKickBan", function(player, toPlayer, type, reason)
    if type == "Ban" then
        mariadb_query(sql, "INSERT INTO `bans` (`steamid`, `ban_time`, `reason`) VALUES ('"..PlayerData[tonumber(toPlayer)].steamid.."', '"..os.time(os.date('*t')).."', '"..reason.."');")

        KickPlayer(tonumber(toPlayer), _("banned_for", reason, os.date('%Y-%m-%d %H:%M:%S', os.time())))
    end
    if type == "Kick" then
        KickPlayer(tonumber(toPlayer), _("kicked_for", reason))
    end
end)

AddCommand("delveh", function(player)
    if tonumber(IsRank(player)) > 0 then return end
    local vehicle = GetPlayerVehicle(player)

    if vehicle ~= nil then
        DestroyVehicle( vehicle )
    end
end)