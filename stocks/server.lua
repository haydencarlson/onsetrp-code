local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local stockTraderId


function PlayerStockDataLoaded(player, globalstocks)
    local playerstocks = {}
    for i = 1, mariadb_get_row_count() do
        local playerstock = mariadb_get_assoc(i)
        playerstocks[playerstock['name']] = string.format("%s (Balance: %s)", playerstock['name'], string.format("%.8f", playerstock['amount']))
    end
    CallRemoteEvent(player, "OpenStockTraderMenu", globalstocks, playerstocks)
end

function GlobalStockDataLoaded(player)
    local globalstocks = {} 
    for i = 1, mariadb_get_row_count() do
        local stock = mariadb_get_assoc(i)
        globalstocks[stock['name']] = string.format("%s ($%s)", stock['name'], string.format("%.2f", stock['price']))
    end
    local playerstocksquery =  mariadb_prepare(sql, "SELECT * from stocks INNER JOIN player_stocks on stocks.id=player_stocks.stock_id WHERE player_id = '?';", PlayerData[player].accountid)
    mariadb_async_query(sql, playerstocksquery, PlayerStockDataLoaded, player, globalstocks)
end

function UpdateOrCreatePlayerStock(existingstock, player, stockid, price, quantity, name)
    if existingstock then
        local updatequery = mariadb_prepare(sql, "UPDATE player_stocks SET amount = amount + '?' WHERE id = '?';", quantity, existingstock['id'])
        mariadb_async_query(sql, updatequery)
    else
        local insertquery = mariadb_prepare(sql, "INSERT INTO player_stocks (player_id, stock_id, amount) VALUES (?, ?, ?);", PlayerData[player].accountid, stockid, quantity)
        mariadb_async_query(sql, insertquery)
    end
    RemoveBalanceFromAccount(player, "cash", price * quantity)
    CallRemoteEvent(player, "MakeNotification", _("bought_stock") .. quantity .. " " .. name, "linear-gradient(to right, #00b09b, #96c93d)")
end

function UpdateStockAmountLoaded(player, quantity, stock)
    local balance = GetPlayerCash(player)
    AddBalanceToAccount(player, "cash", (quantity * stock['price']))
    CallRemoteEvent(player, "MakeNotification", _("sold_stock") .. quantity .. " " .. stock['name'], "linear-gradient(to right, #00b09b, #96c93d)")
end

function LookForExistingStockLoaded(player, stockid, price, quantity, name)
    local existingstock = mariadb_get_assoc(1)
    UpdateOrCreatePlayerStock(existingstock, player, stockid, price, quantity, name)
end

function SingleStockDataLoaded(player, quantity, side)
    local stock = mariadb_get_assoc(1) 
    if tonumber(quantity) <= 0 then
        return CallRemoteEvent(player, "MakeNotification", _("less_then_zero"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
    if side == "buy" then
        local price = stock['price']
        local stockid = stock['id']
        if GetPlayerCash(player) >= tonumber(price) * tonumber(quantity) then
            local existingstock = mariadb_prepare(sql, "SELECT * FROM player_stocks WHERE stock_id = '?' AND player_id = '?';", stockid, PlayerData[player].accountid)
            mariadb_async_query(sql, existingstock, LookForExistingStockLoaded, player, stockid, price, quantity, stock['name'])
        else
            CallRemoteEvent(player, "MakeNotification", _("not_enought_cash"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    else
        local balance = tonumber(stock['amount'])
        local price = stock['price']
        if balance >= tonumber(quantity) then
            if balance - tonumber(quantity) == 0 then
                -- Delete row
                local deleterow = mariadb_prepare(sql, "DELETE from player_stocks where id = '?';", stock['id'])
                mariadb_async_query(sql, deleterow, UpdateStockAmountLoaded, player, quantity, stock)
            else
                -- Update row
                local updatebalance = mariadb_prepare(sql, "UPDATE player_stocks set amount = amount - '?' where id = '?'", quantity, stock['id'])
                mariadb_async_query(sql, updatebalance, UpdateStockAmountLoaded, player, quantity, stock)
            end
        else
            CallRemoteEvent(player, "MakeNotification", _("not_enough_stock"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    end
end

function HandleStockPriceChange()
    for i = 1, mariadb_get_row_count() do
        math.randomseed(os.time())
        local stock = mariadb_get_assoc(i)
        local currentprice = stock['price']
        local percentchange = math.random(-3, 3) / 100
        local newprice = tonumber(stock['price']) + tonumber(stock['price']) * percentchange
        local updateprice = mariadb_prepare(sql, "UPDATE stocks set price = '?' where id = '?'", newprice, stock['id'])
        print("Updated " .. stock['name'] .. ' to ' .. '$' .. newprice)
        mariadb_async_query(sql, updateprice)
    end
end

AddEvent('OnPackageStart', function() 
    stockTraderId = CreateNPC(214410, 190914, 1309, 240)
    CreateText3D(_("stock_trader").."\n".._("press_e"), 18, 214410, 190914, 1309 + 120, 0, 0, 0)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupStockTrader", stockTraderId)
end)

AddRemoteEvent("BuyStocks", function(player, stock, quantity)
    local query = mariadb_prepare(sql, "SELECT * FROM stocks WHERE name = '?';", stock)
	mariadb_async_query(sql, query, SingleStockDataLoaded, player, quantity, "buy")
end)

AddRemoteEvent("SellStocks", function(player, playerstock, quantity)
    local query = mariadb_prepare(sql, "SELECT * from stocks INNER JOIN player_stocks on stocks.id=player_stocks.stock_id WHERE player_id = '?' AND name = '?';", PlayerData[player].accountid, playerstock)
	mariadb_async_query(sql, query, SingleStockDataLoaded, player, quantity, "sell")
end)

AddRemoteEvent("FetchStockData", function(player) 
    local query = mariadb_prepare(sql, "SELECT * FROM stocks;")
	mariadb_async_query(sql, query, GlobalStockDataLoaded, player)
end)

CreateTimer(function() 
    local query = mariadb_prepare(sql, "SELECT * FROM stocks;")
    mariadb_async_query(sql, query, HandleStockPriceChange)
end, 300000 )


AddCommand('wealth', function(player)
    SetPlayerLocation(player, 214410, 190914, 1309)
end)
