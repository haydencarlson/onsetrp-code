

AddRemoteEvent("StartMechanicJob", function(player) 
    PlayerData[player].job = 'mechanic'
end)

AddRemoteEvent("RepairPlayerVehicle", function(player)
    local vehicles = GetAllVehicles()
    local nearest_vehicle = GetNearestVehicle(player, vehicles)
    if nearest_vehicle then
        local vehicle_health =  GetVehicleHealth(nearest_vehicle)
        if vehicle_health ~= 5000 then
            CallRemoteEvent(player, "MakeNotification", "Vehicle has been repaired", "linear-gradient(to right, #00b09b, #96c93d)")
            SetVehicleHealth(nearest_vehicle, 5000)
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