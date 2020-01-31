local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

Items = {}
ItemsWeight = {}
ShopObjectsCached = { }
ShopTable = { }

AddEvent("database:connected", function()
    -- Load items
    mariadb_query(sql, "SELECT * FROM items;", function()
        for i = 1, mariadb_get_row_count() do
            local item = mariadb_get_assoc(i)

            ItemsWeight[item['name']] = 1
            
            table.insert(Items, { 
                id = tonumber(item['id']),
                name = item['name'],
                translated_name = _(item['name']),
                category = item['category'],
                subcategory = item['subcategory'],
                price = tonumber(item['price']),
                weight = 1,
                weightInText = "1",
                hunger = tonumber(item['hunger']),
                thirst = tonumber(item['thirst']),
                usable = tonumber(item['usable']),
                equipable = tonumber(item['equipable'])
            })

        end

        ItemsWeight['cash'] = 0

        -- Load shops
        mariadb_query(sql, "SELECT * FROM shops;", function()
            for i = 1, mariadb_get_row_count() do
                local shop = mariadb_get_assoc(i)
                local shopItems = { }

                for _, item in pairs(Items) do
                    if (item['category'] == shop['category']) then
                        table.insert(shopItems, item)
                    end
                end
                
                table.insert(ShopTable, {
                    id = shop['id'],
                    name = shop['name'],
                    category = shop['category'],
                    items = shopItems,
                    location = { tonumber(shop['x']), tonumber(shop['y']), tonumber(shop['z']), tonumber(shop['h']) },
                    npc = { }
                })
            end

            LoadShopNpcs()
        end)
    end)
end)

function LoadShopNpcs()
    for shopKey, shop in pairs(ShopTable) do
        shop.npc = CreateNPC(shop.location[1], shop.location[2], shop.location[3], shop.location[4])
        CreateText3D(_(shop.name).."\n".._("press_e"), 18, shop.location[1], shop.location[2], shop.location[3] + 120, 0, 0, 0)

        table.insert(ShopObjectsCached, shop.npc)
	end
end

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "shopSetup", ShopObjectsCached)
end)

AddRemoteEvent("shopInteract", function(player, shopNpc)
    local shop = GetShopByObject(shopNpc)

    if shop then
		local x, y, z = GetNPCLocation(shop.npc)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

        if dist < 250 then
            if shop.category == "weapons" and PlayerData[player].gun_license == 0 then
                CallRemoteEvent(player, 'KNotify:Send', _("no_gun_license"), "#f00")
            else
                CallRemoteEvent(player, "openShop", PlayerData[player].inventory, shop.items, shop.npc)
            end
		end
	end
end)

function GetShopByObject(shopNpc)
    for _, shop in pairs(ShopTable) do
        if shop.npc == shopNpc then
            return shop
        end
	end
	return nil
end

function GetItemInfo(item, info, default)
    for _, item in pairs(Items) do
        if item.name == item then
            return item[info]
        end
    end
    return default
end

function getPrice(item)
    GetItemInfo(item, 'price', 0)
end

function getWeight(item)
    GetItemInfo(item, 'weight', 0)
end


AddRemoteEvent("ShopBuy", function(player, shopid, item, amount)
    local itemPrice = item.price * amount

    if GetPlayerCash(player) < itemPrice then
        CallRemoteEvent(player, 'KNotify:Send', _("not_enought_cash"), "#f00")
    else        
        if AddInventory(player, item.name, amount) == true then
            RemoveBalanceFromAccount(player, "cash", itemPrice)
            CallRemoteEvent(player, 'KNotify:Send', _("shop_success_buy", tostring(amount), _(item.name), _("price_in_currency", itemPrice)), "#0f0")
        else
            CallRemoteEvent(player, 'KNotify:Send', _("inventory_not_enough_space"), "#f00")
        end
    end
end)

AddRemoteEvent("ShopSell", function(player, shopid, item, amount) 
    local itemName = item.name
    local itemPrice = item.price * amount * 0.25

    if itemPrice == 0 then
        return
    end

    if tonumber(PlayerData[player].inventory[itemName]) < tonumber(amount) then
        CallRemoteEvent(player, 'KNotify:Send', _("not_enough_item"), "#f00")
    else
        AddBalanceToAccount(player, "cash", math.ceil(itemPrice))
        CallRemoteEvent(player, 'KNotify:Send', _("shop_success_sell", tostring(amount), _(itemName), _("price_in_currency", itemPrice)), "#0f0")
        RemoveInventory(player, itemName, amount)
    end
end)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)

