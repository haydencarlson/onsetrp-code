local function GetNearestPlayer(player)
	local x, y, z = GetPlayerLocation(player)
    for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
        if v ~= player then
            local x2, y2, z2 = GetPlayerLocation(v)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150 then
                return v
            end
        end
	end
	return 0
end


local function IsCopInRange(x, y, z, player)
    local playersinrange = GetPlayersInRange3D(x, y, z, 1000)
    for key, p in pairs(playersinrange) do
        if PlayerData[p].job == 'police' and p ~= player then
            return true
        end
    end
    return false
end

AddEvent("rape", function(player)
    local instigator = player
    local nojob = PlayerData[player].job == ""
    local citizen = PlayerData[player].job == "citizen"
    local victim = GetNearestPlayer(instigator)
    local lastInteract = PlayerData[player].lastinteract == victim
    if lastInteract then
        return CallRemoteEvent(instigator, 'KNotify:Send', "You cannot interact with the same player twice.", "#f00")
    end
    if victim == 0 and (nojob or citizen) and not lastInteract then   
        AddPlayerChat(player, "No one is near you.")
    elseif victim ~= 0 then
        local rapefail = "You have failed to rape ".. PlayerData[victim].name
        local rapefailvic = "You feel your anus expand..."
        local rapesuc = "You have raped ".. PlayerData[victim].name
        local rapesucvic = "You have been raped by " .. PlayerData[instigator].name

        local outcome = Random(1, 3)
        local rapehp = Random(25, 65)
        if outcome > 2 and not lastInteract then
            SetPlayerPropertyValue(victim, "isRaped", 1, true)
            local x, y, z = GetPlayerLocation(instigator)
            SetPlayerHealth(instigator, 100)
            CallRemoteEvent(victim, "AidsOn")
            AddPlayerChat(victim, rapesucvic)
            AddPlayerChat(instigator, rapesuc)
            SetPlayerAnimation(instigator, "HANDSHAKE")
            SetPlayerAnimation(victim, "SIT01")
            CallRemoteEvent(instigator, "LockControlMove", true)
            CallRemoteEvent(victim, "LockControlMove", true)
            PlayerData[player].lastinteract = victim
            if IsCopInRange(x,y,z, player) then
                makeWanted(instigator, player)
            end
            Delay(5000, function()
                SetPlayerAnimation(victim, 'STOP')
                CallRemoteEvent(instigator, "LockControlMove", false)
                CallRemoteEvent(victim, "LockControlMove", false)
            end, instigator, victim)
        else
            AddPlayerChat(instigator, rapefail)
            AddPlayerChat(victim, rapefailvic)
        end
    end
end)

function OnPlayerDeath(player)
    local isRaped = GetPlayerPropertyValue(player, "isRaped")
    if isRaped == 1 then
        CallRemoteEvent(player, "AidsOff")
        SetPlayerPropertyValue(player, "isRaped", 0, true)
    end
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

AddCommand("rape", function(player, instigator)
    if not IsPlayerDead(player) and not GetPlayerPropertyValue(player, 'cuffed') then
      CallEvent("rape", player, instigator)
    end
end)

function OnPackageStart()
    CreateTimer(function()
        for _, v in pairs(GetAllPlayers()) do
            local isRaped = GetPlayerPropertyValue(v, "isRaped")
            if isRaped == 1 then
            local health = GetPlayerHealth(v)
            SetPlayerHealth(v, health - 1)
            end
            if isRaped == 0 then
                return false
            end
        end
    end, 1000)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("rob", function(player)
    local instigator = player
    local victim = GetNearestPlayer(instigator)
    local job = PlayerData[instigator].job == "thief"
    local lastInteract = PlayerData[player].lastinteract == victim
    if lastInteract then
        return CallRemoteEvent(instigator, 'KNotify:Send', "You cannot interact with the same player twice.", "#f00")
    end
    if victim == 0 and job and not lastInteract then  
        AddPlayerChat(player, "No one is near you.")
    elseif victim ~= 0 and job then
        local outcome = Random(1, 3)
        local current_money_victim = GetPlayerCash(victim)
        local current_money = GetPlayerCash(instigator)
        local money = Random(1, 2500)
        local robfail = "You have failed to rob ".. PlayerData[victim].name
        local robfailvic = "You feel your pockets move slightly.."
        local robsuc = "You have robbed $"..money.." from ".. PlayerData[victim].name
        local robsucvic = "Your pockets feel lighter."
        if outcome > 2 and not lastInteract then
            local x, y, z = GetPlayerLocation(instigator)
            RemoveBalanceFromAccount(victim, "cash", money)
            AddBalanceToAccount(instigator, "cash", money) 
            AddPlayerChat(victim, robsucvic)
            AddPlayerChat(instigator, robsuc)
            SetPlayerAnimation(instigator, "HANDSHAKE")
            CallRemoteEvent(instigator, "LockControlMove", true)
            PlayerData[player].lastinteract = victim
            if IsCopInRange(x, y, z, player) and job then
                makeWanted(instigator, player)
            end
            Delay(2500, function()
                CallRemoteEvent(instigator, "LockControlMove", false)
            end)
        else
            AddPlayerChat(instigator, robfail)
            AddPlayerChat(victim, robfailvic)
        end
    end
end)

AddCommand("rob", function(player, instigator)
    if not IsPlayerDead(player) and not GetPlayerPropertyValue(player, 'cuffed') then
    CallEvent("rob", player, instigator)
    end
end)


function OnPlayerChatCommand(player, cmd, exists)
    if not exists then
        CallRemoteEvent(player, 'KNotify:Send', "Command '/"..cmd.."' not found!", "#f00")
	end
	return true
end
AddEvent("OnPlayerChatCommand", OnPlayerChatCommand)
--[[ 

    \=\ cooldown wont work /=/

function OnPlayerChatCommand(player, cmd, exists)
    PlayerData[player].cmd_cooldown = GetTimeSeconds()
    print("bottom time: "..PlayerData[player].cmd_cooldown.."")
    if cmd then
      local cooldowntime = GetTimeSeconds()
        print("cooldown time: "..cooldowntime.."")
        print("mid time: "..PlayerData[player].cmd_cooldown.."")
        if cmd ==  "jh" or cmd == "jobhelp" and exists == false then
        AddPlayerChat(player, "hello")
        elseif not exists then  
        CallRemoteEvent(player, 'KNotify:Send', "Command '/"..cmd.."' not found!", "#f00")
        end
            resultss = cooldowntime - PlayerData[player].cmd_cooldown
    end
    print("Result : "..resultss.."")
      if (resultss < 0.5) then
          print("undercheck time: "..PlayerData[player].cmd_cooldown.."")
          AddPlayerChat(player, "Slow down with your commands")
      end
    return true
end
AddEvent("OnPlayerChatCommand", OnPlayerChatCommand)]]