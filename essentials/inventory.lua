local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

AddRemoteEvent("UseInventory2", function(player, item, amount) 
    weapon = getWeaponID(item)
    if tonumber(PlayerData[player].inventory[item]) < tonumber(amount) then
        AddPlayerChat(player, _("not_enough_item"))
    else
        if weapon ~= 0 then
            SetPlayerWeapon(player, tonumber(weapon), 1000, true, 1)
        else
            if item == "brownstuff" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 6*amount)
            end
		if item == "donut" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 6*amount)
            end
            if item == "cigarette" then
                SetPlayerAnimation(player, "SMOKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 1*amount)
				removePlayerThirst(player, 2*amount)
                --removePlayerHealth(player, 5*amount)
            end
            if item == "apple" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 9*amount)
            end
            if item == "ipecac_syrup" then
                SetPlayerAnimation(player, "VOMIT")
                RemoveInventory(player, item, amount)
                removePlayerHunger(player, 66*amount)
                removePlayerThirst(player, 33*amount)
            end
            if item == "rohypnol_tablet" then
                SetPlayerAnimation(player, "DRUNK")
                RemoveInventory(player, item, amount)
                removePlayerHunger(player, 36*amount)
                removePlayerThirst(player, 12*amount)
            end
            if item == "salad" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 18*amount)
            end
            if item == "slice_pizza" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 27*amount)
            end
            if item == "steak" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 66*amount)
            end
            if item == "chicken_sandwich" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 42*amount)
            end
            if item == "chicken_poutine" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 81*amount)
            end
            if item == "coleslaw" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 6*amount)
            end
            if item == "chicken_bites" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 37*amount)
            end
            if item == "chicken_leg" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 25*amount)
            end
            if item == "chicken_wing" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 15*amount)
            end
            if item == "fried_chicken_rice" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 75*amount)
            end
            if item == "chicken_soup" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 11*amount)
                addPlayerThirst(player, 34*amount)
            end
            if item == "chicken_breast_combo" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 100*amount)
                addPlayerThirst(player, 100*amount)
            end
            if item == "water_bottle" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 60*amount)
            end
            if item == "orange_juice" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 42*amount)
            end
            if item == "milkshake" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 52*amount)
            end
            if item == "coca_cola" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 36*amount)
            end
            if item == "rum" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 22*amount)
            end
            if item == "vodka" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 25*amount)
            end
            if item == "beer" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 47*amount)
            end
            if item == "gin" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 12*amount)
            end
            if item == "wine" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerThirst(player, 8*amount)
            end
            if item == "sandwich" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 26*amount)
            end
            if item == "bbq_hamburger" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 56*amount)
            end
            if item == "fish_chips" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 14*amount)
            end
            if item == "burger_fries" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 77*amount)
            end
			if item == "hamburger" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 51*amount)
            end
			if item == "cheeseburger" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 60*amount)
            end
			if item == "hot_dog" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 21*amount)
            end
			if item == "bbq_hot_dog" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 23*amount)
            end
			if item == "bbq_chicken_wings" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 35*amount)
            end
			if item == "poutine" then
                SetPlayerAnimation(player, "DRINKING")
                RemoveInventory(player, item, amount)
                addPlayerHunger(player, 49*amount)
            end
		if item == "armor" then
                if GetPlayerArmor(player) == 100 then
                    AddPlayerChat(player, _("already_full_armor"))
                else
                    SetPlayerAnimation(player, "COMBINE")
                    RemoveInventory(player, item, amount)
                    SetPlayerArmor(player, 100)
                end
            end

        end
    end
end)
