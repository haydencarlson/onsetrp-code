local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end


-- Joining lottery
AddRemoteEvent("joinLotto", function(player, number)
    if GetPlayerCash(player) >= 50 then
        RemoveBalanceFromAccount(player, 'cash', 50)
        local queryid = mariadb_prepare(sql, "SELECT * from lotteries WHERE status = 'open';")
        mariadb_async_query(sql, queryid, OnLoadedLotteriesCheckPlayer, player, number)
    else
        CallRemoteEvent(player, 'KNotify:Send', _("not_enough_cash_for_lottery"), "#f00")
    end
end)

function OnLoadedLotteriesCheckPlayer(player, number)
    local lottery = mariadb_get_assoc(1)
    local check_entries_for_number = mariadb_prepare(sql, "SELECT * FROM lottery_entries WHERE lotto_number = '?' and lottery_id = '?'", number, lottery['id'])
    mariadb_async_query(sql, check_entries_for_number , OnLoadedCheckForEntryNumber, player, lottery, number)
end

function OnLoadedCheckForEntryNumber(player, lottery, number)
    if (mariadb_get_row_count() ~= 0) then   
        CallRemoteEvent(player, 'KNotify:Send', _("lotto_number_taken"), "#f00")
    else
        local query = mariadb_prepare(sql, "SELECT * FROM lottery_entries WHERE lottery_id = '?' AND accountid = '?';", lottery['id'], PlayerData[player].accountid)
        mariadb_async_query(sql, query , OnLoadInsertEntry, player, number, lottery)
    end
end

function OnLoadInsertEntry(player, number, lottery)
    if (mariadb_get_row_count() ~= 0) then   
        CallRemoteEvent(player, 'KNotify:Send', _("already_entered_lottery"), "#f00")
    else
        local entry = mariadb_get_assoc(1)
        local query = mariadb_prepare(sql, "INSERT INTO lottery_entries SET accountid = '?', lotto_number = '?', lottery_id = '?';",
            tostring(PlayerData[player].accountid),
            tostring(number),
            tostring(lottery['id'])
        )
        mariadb_query(sql, query)
        CallRemoteEvent(player, 'KNotify:Send', _("entered_lottery"), "#0f0")
    end
end

function OnLotteryIdFound(player, number)
    local lottery = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "INSERT INTO lottery_entries SET accountid = '?', lotto_number = '?', lottery_id = '?';",
      tostring(PlayerData[player].accountid),
      tostring(number),
      tostring(lottery['id']))
    mariadb_query(sql, query)
end
    
AddCommand("lottery", function(player)
    CallRemoteEvent(player, "ShowLotteryMenu")
end)

-- Code for finding lottery winner
AddEvent("ServerTimeUpdated", function(serverTime)
    if serverTime == "18:00" then
        local query = mariadb_prepare(sql, "SELECT * from lotteries WHERE status = 'open'; ORDER BY 'id' DESC")
        mariadb_async_query(sql, query, OnLoadedOpenLottery, player)
    end
end)

function OnLoadedOpenLottery(player)
    local lottery = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "SELECT * FROM lottery_entries WHERE lottery_id = '?';", lottery['id'])
    mariadb_async_query(sql, query, OnLoadFindWinner, lottery)
end

function OnLoadFindWinner(lottery)
    local win_amount = 2500
    generated_number = Random(1, 50)
    local winner = {
        found = false,
        account_id = 0,
        name = ""
    }
    -- Loop entries and look for winner
    for i = 1, mariadb_get_row_count() do

        -- Store this entry in local variable
        local entry = mariadb_get_assoc(i)

        -- Does it match the random number
        if tonumber(entry['lotto_number']) == tonumber(generated_number) then
            -- Look for player id by account id
            local player = FindPlayerByAccountId(entry['accountid'])
            winner['found'] = true
            winner['account_id'] = entry['accountid']
            -- If they are online let them know they won
            if player then
                AddPlayerChat(player, "You have won the lottery!")
                AddBalanceToAccount(player, "cash", win_amount)
                winner['name'] = PlayerData[player].name
            else
                -- Update their bank balance
                AddBalanceToBankAccountSQL(entry['accountid'], win_amount)
            end
            break
        end
    end
    UpdateAndCreateNewLotto(lottery, winner)
end

function UpdateAndCreateNewLotto(lottery, winner)
    local update_query

    -- Add to chat lottery number
    AddPlayerChatAll("The lottery has been drawn the number was "..generated_number)

    -- If there was no winner display messages
    if winner['found'] ~= true then
        AddPlayerChatAll("Nobody has won the lottery. Enter again to try for the next one")
        update_query = mariadb_prepare(sql, "UPDATE lotteries SET winner = '?', status = 'closed' WHERE id = '?';",
            "none",
            tostring(lottery['id'])
        )
    else
        if winner['name'] ~= "" then
            AddPlayerChatAll(winner['name'] .. " has won the lottery.")       
        else
            AddPlayerChatAll("Anonymous has won the lottery")
        end
        update_query = mariadb_prepare(sql, "UPDATE lotteries SET winner = '?', status = 'closed' WHERE id = '?';",
            tostring(winner['account_id']),
            tostring(lottery['id'])
        )
    end
    mariadb_query(sql, update_query)

    local open_new_lottery = mariadb_prepare(sql, "INSERT INTO lotteries SET winner = '?', status = '?';",
        "none",
        "open"
    )
    mariadb_query(sql, open_new_lottery)
    AddPlayerChatAll("A new lottery has began /lottery in the chat to enter")
end