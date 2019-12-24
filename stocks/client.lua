local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Dialog = ImportPackage("dialogui")
local traderid
local stockTraderMenu

AddEvent("OnTranslationReady", function()
    stockTraderMenu = Dialog.create(_("stock_trader_menu"), nil, _("buy_stocks"),_("sell_stocks"), _("cancel"))
    Dialog.addSelect(stockTraderMenu, 1, _("stocks"), 5)
    Dialog.addSelect(stockTraderMenu, 2, _("your_stocks"), 5)
    Dialog.addTextInput(stockTraderMenu, 1, _("quantity"))
end)

AddEvent("OnKeyPress", function( key )
    if key == "E" and not onCharacterCreation then
        local NearestStockTrader = GetNearestStockTrader()
        if NearestStockTrader ~= 0 then
            CallRemoteEvent("FetchStockData")
		end
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == stockTraderMenu then
        -- If close is pressed
        if button == 3 then
            Dialog.close(stockTraderMenu)
            return
        end

        -- Quantity is blank
        if args[2] == "" then
            MakeNotification(_("quantity_blank"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end

        -- Buy button
        if button == 1 then
            local stock = args[1]
            local quantity = args[2]
            CallRemoteEvent("BuyStocks", stock, quantity)
        end

        -- Sell button
        if button == 2 then
            local playerstock = args[3]
            local quantity = args[2]
            CallRemoteEvent("SellStocks", playerstock, quantity)
        end
    end
end)

AddRemoteEvent("SetupStockTrader", function(id) 
    traderid = id
end)

AddRemoteEvent("OpenStockTraderMenu", function(globalstocks, playerstocks)
    Dialog.setSelectLabeledOptions(stockTraderMenu, 1, 1, globalstocks)
    Dialog.setSelectLabeledOptions(stockTraderMenu, 2, 1, playerstocks)
    Dialog.show(stockTraderMenu)
end)


function GetNearestStockTrader()
	local x, y, z = GetPlayerLocation()
	for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < 250.0 then
            if v == traderid then
                return v
            end
		end
	end
	return 0
end