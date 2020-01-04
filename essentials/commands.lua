AddCommand("vehdelete", function(player, vehicle) 
if tonumber (PlayerData[player].admin) == 1 then
     local vehicle = GetNearestCar(player)
	DestroyVehicle(vehicle)
		end
end)

AddCommand("gp", function(player)
    local x, y, z = GetPlayerLocation(player)
    AddPlayerChat(player, ""..x..", "..y..", "..z)
    print(player, ""..x..", "..y..", "..z)
end)


AddCommand("advert", function(player, ...)
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[i]
    end
    message = '<span color="#ebc034">[Advert] '..GetPlayerName(player)..':</> '..message
    AddPlayerChatAll(message)
end)
