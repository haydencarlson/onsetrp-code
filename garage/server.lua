local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

GarageDealerObjectsCached = { }
GarageStoreObjectsCached = {}

AddEvent("database:connected", function()
    mariadb_query(sql, "UPDATE `player_garage` SET `garage`=1 WHERE garage = 0;")
end)

 AddEvent("OnPackageStart", function()
    for k,v in pairs(GarageDealerTable) do
        
        -- Create NPC in location
        
        local npcid = CreateNPC(v.location[1], v.location[2], v.location[3], v.location[4])

        local npc = {
            aircraft = v.aircraft,
            id = npcid
        }
        v.npc = npc
        -- Create Text for NPC
        CreateText3D(_("garage").."\n".._("press_e"), 18, v.location[1], v.location[2], v.location[3] + 120, 0, 0, 0)
        
        -- Cache NPC in table
		table.insert(GarageDealerObjectsCached, npc)
    end

    for k,v in pairs(GarageStoreTable) do
        for i,j in pairs(v.location) do
            v.object[i] = CreatePickup(v.modelid , v.location[i][1], v.location[i][2], v.location[i][3])
            CreateText3D(_("store_vehicle"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 120, 0, 0, 0)
            if v.location[i][4] == true then
                SetPickupScale(v.object[i], 8, 8, 1)
            end
            table.insert(GarageStoreObjectsCached, v.object[i])
        end
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "garageDealerSetup", GarageDealerObjectsCached)
end)

AddRemoteEvent("garageDealerInteract", function(player, garagedealerobject)
    local garagedealer = GetGarageDealearByObject(garagedealerobject)
    if garagedealer then
		local x, y, z = GetNPCLocation(garagedealer.npc['id'])
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if dist < 150 then
            sendGarageList(player, garagedealer.npc['aircraft'])
		end
	end
end)

function GetGarageDealearByObject(garagedealerobject)
	for k,v in pairs(GarageDealerTable) do
		if v.npc['id'] == garagedealerobject then
			return v
		end
	end
	return nil
end

function sendGarageList(player, aircraft)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE ownerid = ? AND garage = 1 AND aircraft = '?';",
        PlayerData[player].accountid,
        aircraft)

    mariadb_async_query(sql, query, OnGarageListLoaded, player, aircraft)
end

function OnGarageListLoaded(player)
    local lVehicle = {}
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)
        local id = tostring(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local color = result["color"]
        local name = "vehicle_"..modelid
        local price = math.ceil(result["price"] * 0.25)
        lVehicle[id] = {}
        lVehicle[id].name = name
        lVehicle[id].price = price
    end
    CallRemoteEvent(player, "openGarageDealer", lVehicle)

end

function OnPlayerPickupHit(player, pickup)
    for k,v in pairs(GarageStoreTable) do
        for i,j in pairs(v.object) do
            if j == pickup then
                vehicle = GetPlayerVehicle(player)
                seat = GetPlayerVehicleSeat(player)
                if (vehicle ~= 0 and seat == 1) then
                    if (VehicleData[vehicle].owner == PlayerData[player].accountid) then
                        local query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=1 WHERE `id` = ?;",
                        tostring(VehicleData[vehicle].garageid)
                        )
                        mariadb_async_query(sql, query)
                        DestroyVehicle(vehicle)
                        DestroyVehicleData(vehicle)
                        return CallRemoteEvent(player, 'KNotify:Send', _("vehicle_stored"), "#0f0")
                    end
                end
            end
		end
	end
end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)

function spawnCarServer(player, id)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE id = ?;",
    tostring(id))
    mariadb_async_query(sql, query, spawnCarServerLoaded, player)
end
AddRemoteEvent("spawnCarServer", spawnCarServer)

function spawnCarServerLoaded(player)
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = math.tointeger(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local color = tostring(result["color"])
        local name = _("vehicle_"..modelid)
        local nos_equipped = math.tointeger(result['nos_equipped'])
        local vehicle_durability = math.tointeger(result['vehicle_durability'])
        local query = mariadb_prepare(sql, "UPDATE `player_garage` SET `garage`=0 WHERE `id` = ?;",
            tostring(id)
        )

        local x, y, z = GetPlayerLocation(player)

        for k,v in pairs(GarageDealerTable) do
            local x2, y2, z2 = GetNPCLocation(v.npc)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150.0 then
                local isSpawnable = true
                for k,w in pairs(GetAllVehicles()) do
                    local x3, y3, z3 = GetVehicleLocation(w)
                    local dist2 = GetDistance3D(v.spawn[1], v.spawn[2], v.spawn[3], x3, y3, z3)
                    if dist2 < 1000.0 then
                        isSpawnable = false
                        break
                    end
                end
                if isSpawnable then
                    return SpawnVehicle(modelid, v.spawn[1], v.spawn[2], v.spawn[3], v.spawn[4], nos_equipped, vehicle_durability, id, name, query, player, color)
                else
                    return SpawnVehicle(modelid, v.spawn[1], v.spawn[2] - 300, v.spawn[3], v.spawn[4], nos_equipped, vehicle_durability, id, name, query, player, color)
                end
            end
        end
	end
end

function SpawnVehicle(modelid, x, y, z, h, nos_equipped, vehicle_durability, id, name, query, player, color)
    local vehicle = CreateVehicle(modelid, x, y, z, h)
    if nos_equipped == 1 then
        AttachVehicleNitro(vehicle , true)
    end
    if vehicle_durability == 1 then
        SetVehicleHealth(vehicle, 10000)
    end
    SetVehicleRespawnParams(vehicle, false)
    SetVehicleColor(vehicle, "0x"..color)
    SetVehiclePropertyValue(vehicle, "locked", true, true)
    CreateVehicleData(player, vehicle, modelid)
    VehicleData[vehicle].garageid = id
    mariadb_async_query(sql, query)
    CallRemoteEvent(player, "closeGarageDealer")
    return CallRemoteEvent(player, 'KNotify:Send', _("spawn_vehicle_success", tostring(name)), "#0f0")
end

function sellCarServer(player, id)
    local query = mariadb_prepare(sql, "SELECT * FROM player_garage WHERE id = ?;",
    tostring(id))

    mariadb_async_query(sql, query, sellCarServerLoaded, player)
end
AddRemoteEvent("sellCarServer", sellCarServer)

function sellCarServerLoaded(player)
    for i=1,mariadb_get_row_count() do
        local result = mariadb_get_assoc(i)

        local id = math.tointeger(result["id"])
        local modelid = math.tointeger(result["modelid"])
        local name = _("vehicle_"..modelid)
        local price = math.ceil(result["price"] * 0.61)

        local query = mariadb_prepare(sql, "DELETE FROM `player_garage` WHERE `id` = ?;", tostring(id))
        mariadb_async_query(sql, query)
        AddBalanceToAccount(player, "cash", tonumber(price))
        return CallRemoteEvent(player, 'KNotify:Send', _("sell_vehicle_success", tostring(name), price, _("currency")), "#0f0")
	end
end
