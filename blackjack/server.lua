AddRemoteEvent("NewPlayerGameStart", function(player, bet_amount)
    local new_game = mariadb_prepare(sql, "INSERT INTO blackjack (accountid, bet_amount) VALUES ('?', '?');",
        PlayerData[player].accountid,
        bet_amount
    )
    mariadb_query(sql, new_game)
    
    
end)

AddCommand("blackjack", function(player)
    CallRemoteEvent(player, "ShowBlackJack")
end)
