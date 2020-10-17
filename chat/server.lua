local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

function OnPlayerChat(player, message)
    -- Region message
    local player_who_sent = player
    local streamedPlayers = GetStreamedPlayersForPlayer(player_who_sent)
    if GetPlayerVehicle(player) ~= 0 then
        message = '<span color="#f00000">[Global] </><span>'..GetPlayerName(player)..':</> '..message
        AddPlayerChatAll(message)
        return
    end
    local c = string.sub(message, 1, 1)
	if (c == '@') then
        return AddAdminChat(GetPlayerName(player).."("..player.."): "..string.sub(message, 2))
    end
    local message = '<span>'..GetPlayerName(player)..':</> '..message
    for k,v in pairs(streamedPlayers) do
        AddPlayerChat(v, message)
    end
    AddPlayerChat(player, message)
end
AddEvent("OnPlayerChat", OnPlayerChat)
-- Global chat
AddCommand("/", function(player, ...)
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[i]
    end
    
    message = '<span color="#f00000">[Global] </><span>'..GetPlayerName(player)..':</> '..message
    AddPlayerChatAll(message)
end)

AddCommand("g", function(player, ...)
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[i]
    end
    message = '<span color="#f00000">[Global] </><span>'..GetPlayerName(player)..':</> '..message
    AddPlayerChatAll(message)
end)


-- Private message
AddCommand("p", function(player, toplayer, ...)
    local args = { ... }
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[i]
    end 
    message = '<span color="#00BFFF">['.._("private_message")..']</><span>'..GetPlayerName(player)..':</> '..message
    AddPlayerChat(player, message)
    AddPlayerChat(toplayer, message)
end)

AddCommand("getpos", function(player)
    local x, y, z = GetPlayerLocation(player)
    AddPlayerChat(player, "X : "..x.." Y : "..y.." Z : "..z)
end)
AddCommand("bank", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerLocation(player, 189784.000000, 201549.000000, 835.000000)
end)
AddCommand("cinema", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerLocation(player, 173747.000000, 198165.000000, 2532.000000)
end)
AddCommand("policeplace", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerLocation(player, 171553.000000, 195234.000000, 572.000000)
end)
AddCommand("hos1", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerLocation(player, 215235.000000, 158465.000000, 2960.000000)
end)
AddCommand("hos2", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerLocation(player, 212372.000000, 153763.000000, 2793.000000)
end)
AddCommand("office", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerLocation(player, 191369.000000, 193415.000000, 9366.000000)
end)
AddCommand("spec", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerSpectate( player, true)
end)

AddCommand("end_spec", function(player)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerSpectate( player, false)
end)

AddCommand("tppos", function(player, x, y, z)
    if tonumber(IsRank(player)) < 1 then
        return
    end
    SetPlayerLocation(player, x, y, z)
end)

AddCommand( "doorinfo", function( iPlayer )
    local door = false
    local x, y, z = GetPlayerLocation( iPlayer )

    for k, v in pairs( GetAllDoors() ) do
        local x2, y2, z2 = GetDoorLocation( v )

        if GetDistance3D( x, y, z, x2, y2, z2 ) < 200 then
            door = v
        end
    end

    if not door or not IsValidDoor( door ) then
        AddPlayerChat( iPlayer, "No close door found" )
        return 
    end

    local x, y, z = GetDoorLocation( door )

    print( "{ entity = -1, model = " .. GetDoorModel( door ) .. ", x = " .. x .. ", y = " .. y .. ", z = " .. z .. "}")        
end )