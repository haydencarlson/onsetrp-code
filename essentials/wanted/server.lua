local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

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


AddEvent("makeWanted", function(player)
    local wanted = GetPlayerPropertyValue(player, "isWanted")
    local playername = GetPlayerName(player)
    if wanted == 1 then
    else
        name = '(Criminal) '..playername
        SetPlayerName(player, name)
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

function IsCopInRange(x, y, z)
    local playersinrange = GetPlayersInRange3D(x, y, z, 250)
    for key, p in pairs(playersinrange) do
        if PlayerData[p].job == 'police' then
            return true
        end
    end
    return false
end


AddEvent("arrest", function(player)
    local instigator = player
    local criminal = GetNearestPlayer(instigator)
    local police = PlayerData[instigator].job == "police"
    if criminal == 0 and police then  
        AddPlayerChat(player, "No one is near you.")
    elseif criminal ~= 0 then
        local arrest = "You have arrested ".. PlayerData[criminal].name
        local arrestcrim = "You have been arrested by ".. PlayerData[instigator].name
        local wanted = GetPlayerPropertyValue(player, "isWanted")
        local release = "You have been released from jail."
        AddPlayerChat(instigator, arrest)
        AddPlayerChat(criminal, arrestcrim)
        if wanted == 0 then
            AddPlayerChat(instigator, "Player is not wanted")
        else
           local playername = GetPlayerName(criminal)
           local name = '(In Jail) '..playername
            SetPlayerPropertyValue(player, "isWanted", 0, true)
            SetPlayerLocation(crimnial, -175307.578125, 83121.9921875, 1628.1500244141)
            SetPlayerName(criminal, name)
                Delay(120000, function(criminal)
            SetPlayerLocation(crimnial, -171522.84375, 81275.1171875, 1628.1500244141)
            AddPlayerChat(criminal, release)
            SetPlayerName(criminal, playername) 
            end, criminal)  
        end
    end
end)

AddCommand("arrest", function(player, instigator)
    CallEvent("arrest", player, instigator)
end)
