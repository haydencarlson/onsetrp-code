local MechanicPickup
local vehicleColors = {
    black = '000000',
    red = 'FF0000',
    matallic = 'AAA9AD',
    electric_green = '00FF00',
    orange = 'FFA500',
    yellow = 'FFFF00',
    blue = '0000FF',
    baby_blue = '89CFF0',
    dark_purple = '6A0DAD',
    white = 'FFFFFF',
    light_purple = 'B19CD9',
    dark_red = '8B0000',
    pink = 'FFC0CB'
}
AddEvent("OnPackageStart", function()
    MechanicPickup = CreatePickup(336, 210791.96875, 175153.03125, 1307.1500244141)
    CreateText3D("Mechanic Vehicle Modder" .. "\n" .. "Drive in car" , 18, 210791.96875, 175153.03125, 1307.1500244141, 0, 0, 0)
end)

AddRemoteEvent("StartMechanicJob", function(player) 
    PlayerData[player].job = 'mechanic'
end)

AddRemoteEvent("StopMechanicJob", function(player)
    PlayerData[player].job = ''
end)
AddRemoteEvent("ApplyVehicleMod", function(player, mod, color_name) 
    local vehicle = GetPlayerVehicle(player)
    if vehicle ~= 0 then
        if VehicleData[vehicle].player == player then
            return CallRemoteEvent(player, "MakeNotification", "You cant modify your own vehicle", "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
        local upgrade_action = {
            vehicle_color = function(player, vehicle, color_name) 
                ApplyColorChange(player, vehicle, color_name)
            end,
            vehicle_nos = function(player, vehicle) 
                ApplyNos(player, vehicle, hex)
            end,
            vehicle_durability = function(player, vehicle)
                ApplyVehicleDurability(player, vehicle)
            end
        }
        upgrade_action[mod](player, vehicle, color_name)
    end
end)

function ApplyNos(player, vehicle) 
    local cost = 20000
    if GetPlayerCash(player) >= cost then
        RemoveBalanceFromAccount(player, 'cash', cost)
        AttachVehicleNitro(vehicle, true)
        local update_query = mariadb_prepare(sql, "UPDATE player_garage set nos_equipped = 1 WHERE id = '?';", VehicleData[vehicle].garageid)
        mariadb_query(sql, update_query)
        StartVehicleEngine(vehicle)
        CallRemoteEvent(player, "MakeNotification", "NOS has been added to this vehicle", "linear-gradient(to right, #00b09b, #96c93d)")
    else
        CallRemoteEvent(player, "MakeNotification", "You dont have enough to add NOS", "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end

function ApplyColorChange(player, vehicle, color_name)
    local cost = 500
    if GetPlayerCash(player) >= cost then
        RemoveBalanceFromAccount(player, 'cash', cost)
        print(color_name)
        print(vehicleColors[color_name])
        SetVehicleColor(vehicle, "0x" .. vehicleColors[color_name])
        local update_query = mariadb_prepare(sql, "UPDATE player_garage set color = '?' WHERE id = '?';", vehicleColors[color_name], VehicleData[vehicle].garageid)
        mariadb_query(sql, update_query)
        StartVehicleEngine(vehicle)
        CallRemoteEvent(player, "MakeNotification", "The color has been changed on this vehicle", "linear-gradient(to right, #00b09b, #96c93d)")
    else
        CallRemoteEvent(player, "MakeNotification", "You dont have enough to respray", "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end

function ApplyVehicleDurability(player, vehicle) 
    local cost = 5000
    if GetPlayerCash(player) >= cost then
        RemoveBalanceFromAccount(player, 'cash', cost)
        SetVehicleHealth(vehicle, 10000)
        local update_query = mariadb_prepare(sql, "UPDATE player_garage set vehicle_durability = '?' WHERE id = '?';", '1', VehicleData[vehicle].garageid)
        mariadb_query(sql, update_query)
        StartVehicleEngine(vehicle)
        CallRemoteEvent(player, "MakeNotification", "Vehicle durability increased", "linear-gradient(to right, #00b09b, #96c93d)")
    else
        CallRemoteEvent(player, "MakeNotification", "You dont have enough to upgrade vehicle durability", "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end

AddEvent("OnPlayerPickupHit", function(player, pickup)
    if pickup == MechanicPickup then
        local player_vehicle = GetPlayerVehicle(player)
        if player_vehicle ~= 0 then
            if PlayerData[player].job == 'mechanic' then
                if VehicleData[player_vehicle].player == player then
                    return CallRemoteEvent(player, "MakeNotification", "You cant modify your own vehicle", "linear-gradient(to right, #ff5f6d, #ffc371)")
                end
                StopVehicleEngine(player_vehicle)
                SetVehicleLocation(player_vehicle, 211144.015625, 175584.203125, 1307.1500244141)
                CallRemoteEvent(player, "ShowVehicleModMenu")
            end
        end
    end
end)

AddRemoteEvent("RepairPlayerVehicle", function(player)
    local vehicles = GetAllVehicles()
    local nearest_vehicle = GetNearestVehicle(player, vehicles)
    if nearest_vehicle then
        local vehicle_health = GetVehicleHealth(nearest_vehicle)
        if vehicle_health ~= 5000 then
            CallRemoteEvent(player, "MakeNotification", "Vehicle has been repaired", "linear-gradient(to right, #00b09b, #96c93d)")
            SetVehicleHealth(nearest_vehicle, 5000)
            for i=1,8 do
                SetVehicleDamage(nearest_vehicle, i, 0)
            end
        else
            CallRemoteEvent(player, "MakeNotification", "Vehicle is in perfect shape", "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    else
        CallRemoteEvent(player, "MakeNotification", "No vehicle near you", "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end)

function GetNearestVehicle(player, vehicles)
    local x, y, z = GetPlayerLocation(player)
    for key, vehicle in pairs(vehicles) do
        local x2, y2, z2 = GetVehicleLocation(vehicle)
        local distance = GetDistance3D(x, y, z, x2, y2, z2)
        if distance <= 250 then
            return vehicle
        end
    end
end

AddRemoteEvent("OpenMechanicMenu", function(player) 
    if PlayerData[player].job == 'mechanic' then
        CallRemoteEvent(player, "ShowMechanicMenu")
    end
end)