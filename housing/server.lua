local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

houses = {}

function OnPackageStart()
    -- Save all player data automatically 
    CreateTimer(function()
		for k,v in pairs(houses) do
            SaveHouseData(k)
            
        end
        print("All houses have been saved !")
    end, 30000)
    
end
AddEvent("OnPackageStart", OnPackageStart)

function getHouseDoor(door)
    for k,v in pairs(houses) do
        for i,j in pairs(v.doors) do
            if j.entity == door then
                return k
            end
        end
    end
    return 0
end

function getHouseID(id)
    for k,v in pairs(houses) do
        if v.id == id then
            return k
        end
    end
    return 0
end

function getHouseOwner(player)
    for k,v in pairs(houses) do
        if v.owner == tonumber(PlayerData[player].accountid) then
            return k
        end
    end
    return 0
end

AddEvent("database:connected", function()
    mariadb_query(sql, "SELECT * FROM player_house;", function()
        for i=1,mariadb_get_row_count() do
            local result = mariadb_get_assoc(i)
            local id = getHouseID(tonumber(result['id']))
            

            houses[id].owner = tonumber(result['ownerid'])
            houses[id].spawnable = tonumber(result['spawn'])

            if houses[id].owner == 0 then
                houses[id].txtentities = {
                    CreateText3D( _("house_id").." "..houses[id].id, 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3]+20, 0, 0, 0 ),
                    CreateText3D( _("price").." "..houses[id].price.._("currency"), 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3], 0, 0, 0 )
                }
            else
                mariadb_query(sql, "SELECT name FROM accounts WHERE id='"..houses[id].owner.."';", function()
                    houses[id].txtentities = {
                        CreateText3D( _("house_id").." "..houses[id].id, 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3]+20, 0, 0, 0 ),
                        CreateText3D( _("owner").." "..mariadb_get_value_name(1, "name"), 10, houses[id].text[1] , houses[id].text[2], houses[id].text[3], 0, 0, 0 )
                    }
                end)
            end
        end
    end)
    
end)

AddRemoteEvent("interactHouse", function(player, door) 
    local house = getHouseDoor(door)

    if houses == 0 then
        return
    end

    if houses[house].owner == 0 then
        CallRemoteEvent(player, "OpenHouseBuy", house, houses[house].price)
    else
        if houses[house].owner == tonumber(PlayerData[player].accountid) then
            CallRemoteEvent(player, "OpenHouseMenu", house, houses[house].price)
        end
    end
end)


AddEvent("OnPackageStart", function()
    for k,v in pairs(houses) do
        for k,v in pairs(v.doors) do
            v.entity = CreateDoor( v.model, v.x, v.y, v.z, v.r, true )
        end
    end
end)

AddEvent("OnPlayerInteractDoor", function( player, door, bWantsOpen )
    local house = getHouseDoor(door)
    if house == 0 then
        SetDoorOpen(door, not IsDoorOpen(door))
    else
        if not houses[house].lock then
            SetDoorOpen(door, not IsDoorOpen(door))
        end
    end
end)

AddRemoteEvent("BuyHouse", function(player, house)
    if PlayerData[player].cash < houses[house].price then
        return CallRemoteEvent(player, "MakeNotification", _("not_enought_cash"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end

    if getHouseOwner(player) ~= 0 then
        CallRemoteEvent(player, "MakeNotification", _("already_house_owner"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        RemoveBalanceFromAccount(player, "cash", houses[house].price)
        houses[house].owner = tonumber(PlayerData[player].accountid)
        DestroyText3D(houses[house].txtentities[2])
        houses[house].txtentities[2] = CreateText3D( _("owner").." "..GetPlayerName(player), 10, houses[house].text[1] , houses[house].text[2], houses[house].text[3], 0, 0, 0 )        
    end
end)

AddRemoteEvent("UnlockHouse", function(player, house) 
    if houses[house].owner == tonumber(PlayerData[player].accountid) then
        if houses[house].lock then
            houses[house].lock = false
            CallRemoteEvent(player, "MakeNotification", _("unlock_house"), "linear-gradient(to right, #00b09b, #96c93d)")
        else
            houses[house].lock = true
            CallRemoteEvent(player, "MakeNotification", _("lock_house"), "linear-gradient(to right, #00b09b, #96c93d)")
        end
    end
end)

AddRemoteEvent("SellHouse", function(player, house) 
    if houses[house].owner == tonumber(PlayerData[player].accountid) then
        price = math.ceil(houses[house].price * 0.25)
        AddBalanceToAccount(player, "cash", price)
        houses[house].owner = 0
        CallRemoteEvent(player, "MakeNotification", _("house_sell", price, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
        DestroyText3D(houses[house].txtentities[2])
        houses[house].txtentities[2] = CreateText3D( _("price").." "..houses[house].price.._("currency"), 10, houses[house].text[1] , houses[house].text[2], houses[house].text[3], 0, 0, 0 )        
    end
end)

AddRemoteEvent("SetHouseSpawn", function(player, house)
    if houses[house].owner == tonumber(PlayerData[player].accountid) then
        if houses[house].spawnable == 1 then
            CallRemoteEvent(player, "MakeNotification", _("default_spawn"), "linear-gradient(to right, #00b09b, #96c93d)")
            houses[house].spawnable = 0
        else
            CallRemoteEvent(player, "MakeNotification", _("house_spawn"), "linear-gradient(to right, #00b09b, #96c93d)")
            houses[house].spawnable = 1
        end
    end
end)

function SaveHouseData(house) 
    local query = mariadb_prepare(sql, "UPDATE player_house SET ownerid = '?', spawn = '?' WHERE id = '?' LIMIT 1;",
    houses[house].owner,
    houses[house].spawnable,
    houses[house].id
    )
    
mariadb_query(sql, query)
end

function GetNearestHouseDoor(player)
    local x, y, z = GetPlayerLocation(player)

    for k,v in pairs(houses) do
            for i,j in pairs(v.doors) do
                local x2, y2, z2 = GetDoorLocation( j.entity )
                local dist = GetDistance3D(x, y, z, x2, y2, z2)
                if dist < 150.0 then
                    return j.entity
                end
            end
        end
    return 0
end