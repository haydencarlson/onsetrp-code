AddEvent("rape", function(player)
    victim = GetNearestPlayer(player)
    local rapefail = "You have failed to rape ".. PlayerData[victim].name
    local rapefailvic = "You feel your anus expand..."
    local rapesuc = "You have raped ".. PlayerData[victim].name
    local rapesucvic = "You have been raped by " .. PlayerData[player].name

    debug = victim
    outcome = Random(1, 3)
    rapehp = Random(25, 100)
    if GetNearestPlayer(player) == nil then
        AddPlayerChat(player, "No one is in range.")
    elseif outcome > 2 then
        SetPlayerHealth(victim, -rapehp) 
        SetPlayerHealth(player, 100)
        CallRemoteEvent(victim, "AidsOn")
        AddPlayerChat(victim, rapesucvic)
        AddPlayerChat(player, rapesuc)

    else
        AddPlayerChat(player, rapefail)
        AddPlayerChat(player, debug)
        AddPlayerChat(victim, rapefailvic)
    end

end)



function GetNearestPlayer(player)
	local x, y, z = GetPlayerLocation(player)
	
	for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
        local x2, y2, z2 = GetPlayerLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 50 then
			return k
		end
	end

	return 0
end

AddCommand("rape", function(player, instigator)
      CallEvent("rape", player, instigator)
end)

AddCommand("rf", function(player)
        
    CallRemoteEvent(player, "AidsOn")

end)

AddCommand("rfo", function(player)
        
    CallRemoteEvent(player, "AidsOff")

end)