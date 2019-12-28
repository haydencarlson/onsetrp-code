function getHudData(player)
    playername = GetPlayerName(player)
    armor = GetPlayerArmor(player)
    hunger = math.ceil(PlayerData[player].hunger)
    thirst = math.ceil(PlayerData[player].thirst)
    healthlife = GetPlayerHealth(player)
    health = math.ceil(GetPlayerHealth(player))
    cash = math.ceil(PlayerData[player].cash)
    bank = math.ceil(PlayerData[player].bank_balance)
    job = PlayerData[player].job

    if GetPlayerVehicle(player) ~= 0 then
        if VehicleData[GetPlayerVehicle(player)] == nil then
            vehiclefuel = 0
        else
            vehiclefuel = VehicleData[GetPlayerVehicle(player)].fuel
        end
        vehicle = GetPlayerVehicle(player)
    else
        vehiclefuel = 0
        vehiclespeed = 0
    end

    CallRemoteEvent(player, "updateHud", hunger, thirst, cash, bank, healthlife, vehiclefuel)
    CallRemoteEvent(player, "hud:update", playername, health, armor, hunger, thirst, cash, bank, job)
end
AddRemoteEvent("getHudData", getHudData)

function SetHUDMarker(player, name, heading, r, g, b)
    CallRemoteEvent(player, "SetHUDMarker", name, heading, r, g, b)
end
