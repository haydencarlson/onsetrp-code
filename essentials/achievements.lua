AchData = {}

function CreatePlayerdbAchievements(player)
	local query = mariadb_prepare(sql, "INSERT INTO achievements (id, workday, clothing, fullday, millionaire, bitcoin, secret) VALUES ('?', 'false' , 'false' , 'false', 'false' , 'false');",
		PlayerData[player].accountid)
    print(query)
	mariadb_query(sql, query)
end

function CreateAchievementData(player)
    AchData[player] = {}
    
    AchData[player].workday = false
    AchData[player].fullday = false
    AchData[player].millionaire = false
    AchData[player].bitcoin = false
    AchData[player].secret = false

    print("Achievement Data created for : "..GetPlayerName(player))
end

function LoadPlayerAchievements(player)
    local query = mariadb_prepare(sql, "SELECT * FROM achievements WHERE id = ?;",
        PlayerData[player].accountid)
    
    mariadb_async_query(sql, query, OnAchievementsLoaded, player)
end

function OnAchievementsLoaded(player)
        local result = mariadb_get_assoc(1)
    
        AchData[player].workday = math.tointeger(result['workday'])
        AchData[player].fullday = math.tointeger(result['fullday'])
        AchData[player].millionaire = math.tointeger(result['millionaire'])
        AchData[player].bitcoin = math.tointeger(result['bitcoin'])
        AchData[player].secret = math.tointeger(result['secret'])
        print("Loaded achievemnents for ID: "..PlayerData[player].accountid)
end

function SaveAchievements(player)
	if (PlayerData[player] == nil) then
		return
	end
	if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end
	
	local query = mariadb_prepare(sql, "UPDATE achievements SET workday = ?, fullday = ?, millionaire = ?, bitcoin = ?, secret = ? WHERE id = ? LIMIT 1;",
    AchData[player].workday,
    AchData[player].fullday,
    AchData[player].millionaire,
    AchData[player].bitcoin,
    AchData[player].secret,
    PlayerData[player].accountid
    ) 
    print(query)
    mariadb_query(sql, query)
    
end

function OnPackageStart()
    CreateTimer(function()
		for k, v in pairs(GetAllPlayers()) do
			SaveAchievements(v)
		end
		print("Achievements have been saved")
	end, 30000)
end
AddEvent("OnPackageStart", OnPackageStart)

AddEvent("OnPackageStop", function()
    for k, v in pairs(GetAllPlayers()) do
        SaveAchievements(v)
    end
    print("Achievements have been saved")
end)

function OnPlayerQuit(player)
    SaveAchievements(player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnPlayerSteamAuth(player)
    CreateAchievementData(player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

--[[
local achievements = {
    1 = {
        name = "One work day",
        desc = "8 hours of play time.",
        achieved = false
    },
    2 = {
        name = "One full day",
        desc = "24 hours of play time.",
        achieved = false
    },
    3 = {
        name = "Millionaire",
        desc = "Obtain 1 million dollars.",
        achieved = false
    },
    4 = {
        name = "Crypto is the way to go.",
        desc = "Buy the bitcoin company upgrade.",
        achieved = false
    },
    5 = {
        name = "Its a secret...",
        desc = "has said the secret phrase.",
        achieved = false
    }
}]]