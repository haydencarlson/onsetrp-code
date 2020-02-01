local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local function GetNearestPlayer(player)
	local x, y, z = GetPlayerLocation(player)
    for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
        if v ~= player then
            local x2, y2, z2 = GetPlayerLocation(k)
            local dist = GetDistance3D(x, y, z, x2, y2, z2)
            if dist < 150 then
                return v
            end
        end
	end
	return nil
end

AddRemoteEvent("SeeIdCard", function(player)
    -- Coming soon: job and jobTitle
    -- CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].name, playerInfo['company']['name'], playerInfo['job'])
    CallRemoteEvent(player, "OnCardDataLoaded", PlayerData[player].accountid, PlayerData[player].name, PlayerData[player].driver_license == 1, PlayerData[player].gun_license == 1, PlayerData[player].helicopter_license == 1, PlayerData[player].job)
end)

AddRemoteEvent("ShowIdCard", function(player)
    local nearestPlayer = GetNearestPlayer(player)
    if(nearestPlayer ~= nil) then
	    CallRemoteEvent(nearestPlayer, "OnCardDataLoaded", PlayerData[player].accountid, PlayerData[player].name)
    else
        CallRemoteEvent(player, 'KNotify:Send', _("no_players_around"), "#f00")
	end
end)
