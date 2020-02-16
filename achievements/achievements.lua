function AchievementSearch(player)
    CreateTimer(function(player)     
        for k, v in pairs(GetAllPlayers()) do
            if AchData[v].workday == 0 then
                if tonumber(PlayerData[v].time) > 28799 then
                    AchData[v].workday = 1
                end
            end
        end

        for k, v in pairs(GetAllPlayers()) do
            if AchData[v].fullday == 0 then
                if tonumber(PlayerData[v].time) > 86399 then
                    AchData[v].fullday = 1
                end
            end
        end

        for k, v in pairs(GetAllPlayers()) do
            if AchData[v].millionaire == 0 then
                if (PlayerData[v].bank_balance + GetPlayerCash(v)) > 1000000 then
                    AchData[v].millionaire = 1
                end
            end
        end
        
        for k, v in pairs(GetAllPlayers()) do
            if AchData[v].bitcoin == 0 then
                if PlayerData[v].company_upgrades['bitcoinminer'] == 1 then
                    AchData[v].bitcoin = 1
                end
            end
        end
    end, 1000, player)

    function OnPlayerChat(player, message)
        if AchData[player].secret == 0 then
            if (tostring(message) == 'I cannot go one day without a chicken wing.') then
                AchData[player].secret = 1
            end
        end
    end
    AddEvent("OnPlayerChat", OnPlayerChat)

end
AddEvent("AchievementSearch", AchievementSearch)