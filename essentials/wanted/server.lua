AddEvent("makeWanted", function(player)
    SetPlayerPropertyValue(player, "isWanted", 1, true)
    AddPlayerChat(player, "You are wanted by the police!")

    Delay(80000, function()
        SetPlayerPropertyValue(player, "isWanted", 0, true)
        AddPlayerChat(player, "You escaped the law.")
    end)

end)

AddEvent("bankRob", function(player)
    SetPlayerPropertyValue(player, "isWanted", 1, true)
    AddPlayerChat(player, "You are robbing the bank.")

    Delay(1000000, function()
        SetPlayerPropertyValue(player, "isWanted", 0, true)
        AddPlayerChat(player, "You successfully escaped the bank robbery.")
    end)

end)

function OnPlayerDeath(player, instigator)
local x, y, z = GetPlayerLocation(player)
    message = '<span color="#9B0700">You were killed by '..GetPlayerName(instigator)..'('..player..')</> '
    death = '<span color="#9B0700">You played yourself!</> '
   
   if player == instigator then 
      AddPlayerChat(player,  death)  

   else if GetPlayersInRange3D(x, y, z, 250) and PlayerData[player].job == "police" then
      CallEvent(instigator, "makeWanted")

   else
     AddPlayerChat(player,  message)
        end
    end

end
