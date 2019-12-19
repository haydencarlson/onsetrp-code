local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

ShopObjectsCached = { }
ShopTable = { }
AddEvent("OnPackageStart", function()
    for k,v in pairs(ShopTable) do
        for i,j in pairs(v.location) do
            v.npc[i] = CreateNPC(v.location[i][1], v.location[i][2], v.location[i][3], v.location[i][4])
            CreateText3D(_("shop").."\n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 120, 0, 0, 0)
    
            table.insert(ShopObjectsCached, v.npc[i])
        end
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "shopSetup", ShopObjectsCached)
end)

AddRemoteEvent("shopInteract", function(player, shopobject)
    local shop, npcid = GetShopByObject(shopobject)

	if shop then
		local x, y, z = GetNPCLocation(shop.npc[npcid])
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250 then
			for k,v in pairs(ShopTable) do
				if shopobject == v.npc[npcid] then
					CallRemoteEvent(player, "openShop", PlayerData[player].inventory, v.items, v.npc[npcid])
				end
			end  
			
		end
	end
end)

function GetShopByObject(shopobject)
    for k,v in pairs(ShopTable) do
        for i,j in pairs(v.npc) do
            if j == shopobject then
                return v,i
            end
        end
	end
	return nil
end

function getPrice(shop, item)
    for k,v in pairs(ShopTable) do
        for i,j in pairs(v.npc) do
            if j == shop then
                return v.items[item]
            end
        end
    end
    return 0
end


AddRemoteEvent("ShopBuy", function(player, shopid, item, amount) 
    local price = getPrice(shopid, item) * amount

    if PlayerData[player].cash < price then
        CallRemoteEvent(player, "MakeNotification", _("not_enought_cash"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        PlayerData[player].cash = PlayerData[player].cash - price
        CallRemoteEvent(player, "MakeNotification", _("shop_success_buy", _(item), price, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
        AddInventory(player, item, amount)
    end
end)

AddRemoteEvent("ShopSell", function(player, shopid, item, amount) 
    local price = getPrice(shopid, item) * amount * 0.42

    if price == 0 then
        return
    end

    if tonumber(PlayerData[player].inventory[item]) < tonumber(amount) then
        CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    else
        PlayerData[player].cash = PlayerData[player].cash + math.ceil(price)
        CallRemoteEvent(player, "MakeNotification", _("shop_success_sell", _(item), price, _("currency")), "linear-gradient(to right, #00b09b, #96c93d)")
        RemoveInventory(player, item, amount)
    end
end)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)

