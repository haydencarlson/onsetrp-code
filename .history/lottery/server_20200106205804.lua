AddEvent("joinLotto", function(player, number)
    PlayerData[player].lotto_number = number
    message = "Your number is "..PlayerData[player].lotto_number
    AddPlayerChat(player, message)
    local queryid = mariadb_prepare(sql, "SELECT * from lotteries WHERE status = 'open';")
    mariadb_async_query(sql, queryid, OnLotteryIdFound, player, number)
end)

function OnLotteryIdFound(player, number)
    local lottery = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "INSERT INTO lottery_entries SET accountid = '?', lotto_number = '?', lottery_id = '?';",
    tostring(PlayerData[player].accountid),
      tostring(PlayerData[player].lotto_number),
      tostring(lottery['id'])
    )
    mariadb_query(sql, query)
end
    
AddCommand("lottery", function(player, number)
    CallEvent("joinLotto", player, number)
end)

function OnPackageStart(player)
    CreateTimer(function()
        local none = "none"
        local open = "open"
        local query = mariadb_prepare(sql, "INSERT INTO lotteries SET winner = '?', status = '?';",
        none,
        open
      )
      mariadb_query(sql, query)   

        local query = mariadb_prepare(sql, "SELECT * from lotteries WHERE status = 'open';")
        mariadb_async_query(sql, query, OnLoadedOpenLottery)
    end, 3000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnLoadedOpenLottery(player)
    local lottery = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "SELECT * FROM lottery_entries WHERE lottery_id = '?';", lottery['id'])
    mariadb_async_query(sql, query, OnLoadedLotteryEntries)
end

function OnLoadedLotteryEntries(player)
    generated_number = Random(1, 150)
    for i = 1, mariadb_get_row_count() do
        local entry = mariadb_get_assoc(i)
        if tonumber(entry['lotto_number']) == tonumber(generated_number) then
            local player = FindPlayerByAccountId(entry['accountid'])
           AddPlayerChat(player, "You Won")
        else
        AddPlayerChatAll("The lottery has been drawn the number is "..generated_number)
        local query = mariadb_prepare(sql, "TRUNCATE TABLE lottery_entries;")
      mariadb_query(sql, query)  
        end
    end
end