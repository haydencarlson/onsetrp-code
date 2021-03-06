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
	return 0
end

function makeWanted(player)
    local wanted = GetPlayerPropertyValue(player, "isWanted")
    local playername = GetPlayerName(player)
    local police = PlayerData[player].job == 'police'
    if wanted == 0 and not police then
        name = '(Criminal) '..playername
        SetPlayerName(player, name)
        SetPlayerPropertyValue(player, "isWanted", 1, true)
        CallRemoteEvent(player, 'KNotify:Send', _("make_wanted"), "#f00")

        Delay(120000, function(player)
            local wanted = GetPlayerPropertyValue(player, "isWanted")
            if wanted == 1 then
                SetPlayerPropertyValue(player, "isWanted", 0, true)
                CallRemoteEvent(player, 'KNotify:Send', _("bank_rob"), "#f00")
                SetPlayerName(player, PlayerData[player].name)
            end
        end, player)
    end
end
AddEvent("makeWanted", makeWanted)

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

function IsCopInRange(x, y, z)
    local playersinrange = GetPlayersInRange3D(x, y, z, 250)
    for key, p in pairs(playersinrange) do
        if PlayerData[p].job == 'police' then
            return true
        end
    end
    return false
end


AddCommand("want", function(player, instigator)
    local instigator = player
    local criminal = GetNearestPlayer(player)
    local police = PlayerData[player].job == "police"
    local copname = GetPlayerName(instigator)
    if PlayerData[criminal].job == 'police' then
       return AddPlayerChat(player, "You cant make a police officer wanted")
    end
    if criminal == 0 and police then  
        AddPlayerChat(player, "No one is near you.")
    elseif criminal ~= 0 and police then
        makeWanted(criminal)
        AddPlayerChat(criminal, "Officer "..copname.." has made you wanted by the law.")
    end
end)

AddEvent("arrest", function(player)
    local instigator = player
    local criminal = GetNearestPlayer(instigator)
    local police = PlayerData[instigator].job == "police"
    if criminal == 0 and police then  
        AddPlayerChat(player, "No one is near you.")
    elseif criminal ~= 0 and police then
        local arrest = "You have arrested ".. PlayerData[criminal].name
        local arrestcrim = "You have been arrested by ".. PlayerData[instigator].name
        local wanted = GetPlayerPropertyValue(criminal, "isWanted")
        local release = "You have been released from jail."
        local paypolice = "You have received 50$ for arresting ".. PlayerData[criminal].name
        if wanted == 0 then
            AddPlayerChat(instigator, "Player is not wanted")
        elseif wanted == 1 then
            AddPlayerChat(instigator, arrest)
            AddPlayerChat(criminal, arrestcrim)
            CallEvent("OnPlayerArrest", criminal)
            local playername = GetPlayerName(criminal)
            local name = '(In Jail) '..playername
            AddBalanceToAccount(instigator, "cash", 50)
            AddPlayerChat(instigator, paypolice) 
            SetPlayerPropertyValue(player, "isWanted", 0, true)
            SetPlayerName(criminal, name)
            SetPlayerLocation(criminal, -175307.578125, 83121.9921875, 1660.1500244141)
            Delay(120000, function(criminal)
                local name = PlayerData[criminal].name
                SetPlayerLocation(criminal, -171522.84375, 81275.1171875, 1628.1500244141)
                AddPlayerChat(criminal, release)
                SetPlayerName(criminal, name) 
            end, criminal)  
        end
    end
end)

AddCommand("arrest", function(player, instigator)
    if not IsPlayerDead(player) and not GetPlayerPropertyValue(player, 'cuffed') then
        CallEvent("arrest", player, instigator) 
    end
end)

AddEvent("OnPlayerArrest", function(player)
    SetPlayerPropertyValue(player, "isWanted", 0, true)
    CallRemoteEvent(player, 'KNotify:Send', _("bank_rob"), "#f00")
    SetPlayerName(player, PlayerData[player].name)
    SetPlayerWeapon(player, 1, 0, true, 1, false)
    SetPlayerWeapon(player, 1, 0, true, 2, false)
    SetPlayerWeapon(player, 1, 0, true, 3, false)
    FreeHandcuffPlayer(player)
end)