local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AddEvent("makeWanted", function(player)
    SetPlayerPropertyValue(player, "isWanted", 1, true)
    CallRemoteEvent(player, "MakeNotification", _("make_wanted"), "linear-gradient(to right, #ff5f6d, #ffc371)")

    Delay(80000, function()
        SetPlayerPropertyValue(player, "isWanted", 0, true)
        CallRemoteEvent(player, "MakeNotification", _("bank_rob"), "linear-gradient(to right, #ff5f6d, #ffc371)")
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
