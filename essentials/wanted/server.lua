local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end


AddCommand("want", function(player)
    CallEvent("makeWanted", player)
end)

AddEvent("makeWanted", function(player)
   local wanted = GetPlayerPropertyValue(player, "isWanted") 
    playername = GetPlayerName(player)
    name = '(Criminal) '..playername
    SetPlayerName(player, name)
    if wanted == 1 then
    else
     SetPlayerPropertyValue(player, "isWanted", 1, true)
    CallRemoteEvent(player, "MakeNotification", _("make_wanted"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    

    Delay(80000, function()
        SetPlayerPropertyValue(player, "isWanted", 0, true)
        CallRemoteEvent(player, "MakeNotification", _("bank_rob"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        SetPlayerName(player, PlayerData[player].name)
        end)
    end
end)

AddEvent("bankRob", function(player)
    local wanted = GetPlayerPropertyValue(player, "isWanted")
    if wanted == 1 then
    else
    SetPlayerPropertyValue(player, "isWanted", 1, true)
    AddPlayerChat(player, "You are robbing the bank.")

    Delay(1000000, function()
        SetPlayerPropertyValue(player, "isWanted", 0, true)
        AddPlayerChat(player, "You successfully escaped the bank robbery.")
    end)
  end
end)

function OnPlayerDeath(player, instigator)
    local playersinrange = GetPlayersInRange3D(x, y, z, 250)
    local cops_in_range = false
    message = '<span color="#9B0700">You were killed by '..GetPlayerName(instigator)..'('..player..')</> '
    death = '<span color="#9B0700">You played yourself!</> '
    
    if player == instigator then 
        AddPlayerChat(player,  death)  
    else if IsCopInRange(x,y,z) then
        CallEvent(instigator, "makeWanted")
    else
        AddPlayerChat(player,  message)
    end
end
end
AddRemoteEvent("OnPlayerDeath", OnPlayerDeath)



function IsCopInRange(x, y, z)
    local playersinrange = GetPlayersInRange3D(x, y, z, 250)
    for key, p in pairs(playersinrange) do
        if PlayerData[p].job == 'police' then
            return true
        end
    end
    return false
end
