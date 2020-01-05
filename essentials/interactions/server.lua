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

AddEvent("rape", function(player)
    local instigator = player
    local victim = GetNearestPlayer(instigator)
    if victim ~= 0 then
        local rapefail = "You have failed to rape ".. PlayerData[victim].name
        local rapefailvic = "You feel your anus expand..."
        local rapesuc = "You have raped ".. PlayerData[victim].name
        local rapesucvic = "You have been raped by " .. PlayerData[instigator].name

        local outcome = Random(1, 3)
        local rapehp = Random(25, 100)
        if outcome > 2 then
            local current_health = GetPlayerHealth(victim)
            SetPlayerHealth(victim, current_health - rapehp) 
            SetPlayerHealth(instigator, 100)
            CallRemoteEvent(victim, "AidsOn")
            AddPlayerChat(victim, rapesucvic)
            AddPlayerChat(instigator, rapesuc)

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