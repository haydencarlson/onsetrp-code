AddEvent("rape", function(player, toPlayer)
    local rapefail = "You have failed to rape ".. toPlayer
    local rapefailvic = "You feel your anus expand..."
    local rapesuc = "You have raped ".. toPlayer
    local rapesucvic = "You have been raped by " .. player
    debug = toPlayer
    outcome = Random(1, 3)
    rapehp = Random(25, 100)
    
    if outcome > 2 then
        SetPlayerHealth(toPlayer, -rapehp) 
        SetPlayerHealth(player, 100)

        CallRemoteEvent(toPlayer, "AidsOn")

        AddPlayerChat(toPlayer, rapesucvic)
        AddPlayerChat(player, rapesuc)
        AddPlayerChat(player, debug)

    else

        AddPlayerChat(player, rapefail)
        AddPlayerChat(player, debug)
        AddPlayerChat(toPlayer, rapefailvic)
        
    end

end)

AddCommand("rape", function(player, toPlayer)
        
      CallEvent("rape", player, toPlayer)

end)

AddCommand("rf", function(player)
        
    CallRemoteEvent(player, "AidsOn")

end)

AddCommand("rfo", function(player)
        
    CallRemoteEvent(player, "AidsOff")

end)