AddEvent("joinLotto", function(player, number)
    PlayerData[player].lotto_number = number
    print("number")
    local query = mariadb_prepare(sql, "SELECT * FROM lotteries where status = 'open';")
    mariadb_async_query(sql, query, OnSubmitLotto, player)
    print(query)
end)

function OnSubmitLotto(player)
    print("submit")
    local lottery = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "SELECT * FROM lottery_entries WHERE accountid = '?' and lottery_id = '?';", PlayerData[player].accountid, lottery['id'])
    mariadb_async_query(sql, query, OnNewEntryCheck, player)
end

function OnNewEntryCheck(player)
    local existing_entry = mariadb_get_assoc(1)
    if existing_entry == nil then
         AddPlayerChat(player, 'you are already entered into this lottery')
    else
    local lottery = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "INSERT INTO lottery_entries SET accountid = '?', lotto_number = '?', lottery_id = '?';",
    tostring(PlayerData[player].accountid),
      tostring(PlayerData[player].lotto_number),
      tostring(lottery['id'])
    )
    mariadb_query(sql, query)
    message = "Your number is "..PlayerData[player].lotto_number
    AddPlayerChat(player, message)
    end
end

AddCommand("lottery", function(player, number)
    CallEvent("joinLotto", player, number)
end)

function OnPackageStart(player)
    CreateTimer(function()
        local query = mariadb_prepare(sql, "SELECT * from lotteries WHERE status = 'open'; ORDER BY 'id' DESC")
        mariadb_async_query(sql, query, OnLoadedOpenLottery)
    end, 15000)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnLoadedOpenLottery(player)
    local lottery = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "SELECT * FROM lottery_entries WHERE lottery_id = '?';", lottery['id'])
    mariadb_async_query(sql, query, OnLoadedLotteryEntries)
end

function OnLoadedLotteryEntries(player)
    generated_number = 88
    for i = 1, mariadb_get_row_count() do
        local entry = mariadb_get_assoc(i)
        print(tostring(entry['lottery_id']))
        if tonumber(entry['lotto_number']) == tonumber(generated_number) then
           local player = FindPlayerByAccountId(entry['accountid'])
           AddPlayerChat(player, "You Won")
           local query = mariadb_prepare(sql, "UPDATE lotteries SET winner = '?', status = 'closed' WHERE id = '?';",
           tostring(PlayerData[player].accountid),
           tostring(entry['lottery_id'])
                )
           mariadb_query(sql, query)
        AddPlayerChatAll("The lottery has been drawn the number is "..generated_number)
    else
        local none = "none"
        local query = mariadb_prepare(sql, "UPDATE lotteries SET winner = '?', status = 'closed' WHERE id = '?';",
           none,
           tostring(entry['lottery_id'])
                )
            mariadb_query(sql, query)
        AddPlayerChatAll("The lottery has been drawn the number is "..generated_number)
    end
    local none = "none"
    local open = "open"
    local query2 = mariadb_prepare(sql, "INSERT INTO lotteries SET winner = '?', status = '?';",
    none,
    open
  )
  mariadb_query(sql, query2)
    end
end