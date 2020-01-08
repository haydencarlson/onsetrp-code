local function GetNearestPlayer(player)
	local x, y, z = GetPlayerLocation(player)
    for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
        if k ~= player then
            local x2, y2, z2 = GetPlayerLocation(k)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150 then
                return k
            end
        end
	end
	return 0
end


local function IsCopInRange(x, y, z)
    local playersinrange = GetPlayersInRange3D(x, y, z, 1000)
    for key, p in pairs(playersinrange) do
        if PlayerData[p].job == 'police' then
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
    if victim == 0 and nojob or citizen then   
        AddPlayerChat(player, "No one is near you.")
    elseif victim ~= 0 then
        local rapefail = "You have failed to rape ".. PlayerData[victim].name
        local rapefailvic = "You feel your anus expand..."
        local rapesuc = "You have raped ".. PlayerData[victim].name
        local rapesucvic = "You have been raped by " .. PlayerData[instigator].name

        local outcome = Random(1, 3)
        local rapehp = Random(25, 65)
        if outcome > 2 then
            local current_health = GetPlayerHealth(victim)
            local x, y, z = GetPlayerLocation(instigator)
            SetPlayerHealth(victim, current_health - rapehp) 
            SetPlayerHealth(instigator, 100)
            CallRemoteEvent(victim, "AidsOn")
            AddPlayerChat(victim, rapesucvic)
            AddPlayerChat(instigator, rapesuc)
            SetPlayerAnimation(instigator, "HANDSHAKE")
            SetPlayerAnimation(victim, "SIT01")
            CallRemoteEvent(instigator, "LockControlMove", true)
            CallRemoteEvent(victim, "LockControlMove", true)
            if IsCopInRange(x,y,z) then
                CallEvent("makeWanted", instigator)
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

AddCommand("rape", function(player, instigator)
      CallEvent("rape", player, instigator)
end)

AddCommand("rf", function(player)
        
    CallRemoteEvent(player, "AidsOn")

end)

AddCommand("rfo", function(player)
    CallRemoteEvent(player, "AidsOff")
end)

AddEvent("rob", function(player)
    local instigator = player
    local victim = GetNearestPlayer(instigator)
    local job = PlayerData[instigator].job == "thief"
    if victim == 0 and job then  
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
        if outcome > 2 then
            local x, y, z = GetPlayerLocation(instigator)
            RemoveBalanceFromAccount(victim, "cash", money)
            AddBalanceToAccount(instigator, "cash", money) 
            AddPlayerChat(victim, robsucvic)
            AddPlayerChat(instigator, robsuc)
            SetPlayerAnimation(instigator, "HANDSHAKE")
            CallRemoteEvent(instigator, "LockControlMove", true)
            if IsCopInRange(x,y,z) and job then
                CallEvent("makeWanted", instigator)
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
    CallEvent("rob", player, instigator)
end)