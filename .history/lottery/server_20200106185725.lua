AddEvent("joinLotto", function(player, number)
    PlayerData[player].lotto_number = number
    message = "Your number is "..PlayerData[player].lotto_number
  AddPlayerChat(player, message)

  local query = mariadb_prepare(sql, "INSERT INTO lottery_entries SET accountid = '?', lotto_number = '?';",
  tostring(PlayerData[player].accountid),
  tostring(PlayerData[player].lotto_number)
)
print(PlayerData[player].accountid)
mariadb_query(sql, query)
end)

AddCommand("lottery", function(player, number)
    CallEvent("joinLotto", player, number)
end)

function OnPackageStart(player)
    CreateTimer(function()
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
    generated_number = 77
    for i = 1, mariadb_get_row_count() do
        local entry = mariadb_get_assoc(i)
        print("before if")
        print(tonumber(entry['lotto_number']))
        if tonumber(entry['lotto_number']) == tonumber(generated_number) then
            
            local player = FindPlayerByAccountId(entry['accountid'])
            AddPlayerChat(player, "You Won")
        end
        print("after if")
    end
    print("after loop")
end