local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
vaultTimer = 0 
vaultLockProgress = 0
local vaultProgressText 
AddEvent("OnPackageStart", function()
    bankenterobject = CreateObject(340, 191911, 198230, 1309)
    SetObjectPropertyValue(bankenterobject, "action", "bankenter", true)
    CreateText3D(_("enter_bank").."\n".._("press_e"), 18, 191911, 198230, 1309 + 120, 0, 0, 0)

    bankleaveobject = CreateObject(340, 189914, 201541, 813)
    SetObjectPropertyValue(bankleaveobject, "action", "bankleave", true)
    CreateText3D(_("leave_bank").."\n".._("press_e"), 18, 189914, 201541, 813 + 120, 0, 0, 0)
    bankbars = CreateObject(1487, 183977, 202876, 50)
    CreateText3D(_("press_e"), 20, 183977, 202950, 250, 0, 0, 0)
    SetObjectPropertyValue(bankbars, "action", "stealbars", true)

    bartradernpc = CreateNPC(151589, 203814, 363, 240)
    SetNPCPropertyValue(bartradernpc, "action", "trade_silver_bars", true)
    CreateText3D(_("press_e"), 18, 151584, 203722, 380, 0, 0, 0)

    vaultProgressText = CreateText3D("Picklock Progress: " .. vaultLockProgress .. " %", 18, 185145.328125, 203271.4375, 160.6325378418, 0, 0, 0)
end)

AddEvent("OnPlayerInteractDoor", function( player, door, bWantsOpen )
    if globaldoors[door] ~= nil and globaldoors[door].locked then
        SetDoorOpen(door, false)
        CallRemoteEvent(player, 'KNotify:Send', _("vault_locked"), "#f00")
    end
end)

AddRemoteEvent("StartThiefJob", function(player)
    PlayerData[player].job = "thief"
end)

AddRemoteEvent("StopThiefJob", function(player)
    PlayerData[player].job = ""
end)

AddRemoteEvent("PickOpenDoor", function(player)
    if PlayerData[player].job == "thief" and GetPlayerPropertyValue(player, "actionInProgress") == 'false' then
        if vaultTimer <= 0 then
            local nearestdoor = GetNearestDoor(player)
            if globaldoors[nearestdoor] ~= nil then
                if vaultLockProgress == 0 then
                    AddPlayerChatAll('<span color="#ff0000">' .. GetPlayerName(player) .. ' is hitting the bank vault. Stop them from stealing the banks money</>')
                end
                SetPlayerPropertyValue(player, 'actionInProgress', 'true', true)
                LockPickAnimation(player)
                CallEvent("bankRob", player)
                if vaultLockProgress + 5 < 100 then
                    Delay(2000, function()
                        vaultLockProgress = vaultLockProgress + 5
                        SetText3DText(vaultProgressText, "Picklock Progress: " .. vaultLockProgress .. " %")
                        SetPlayerPropertyValue(player, 'actionInProgress', 'false', true)
                    end)
                else
                    SetPlayerPropertyValue(player, 'actionInProgress', 'false', true)
                    SetText3DText(vaultProgressText, "Picklock Progress: 100 %")
                    globaldoors[nearestdoor].locked = false
                    SetDoorOpen(nearestdoor, true)
                    CallRemoteEvent(player, 'KNotify:Send', _("door_picklocked"), "#0f0")
                    Delay(60000, function()
                        SetText3DText(vaultProgressText, "Picklock Progress: 0 %")
                        vaultLockProgress = 0
                        if IsDoorOpen(nearestdoor) then
                            SetDoorOpen(nearestdoor, false)
                        end
                        globaldoors[nearestdoor].locked = true
                    end)
                end
            else
                CallRemoteEvent(player, 'KNotify:Send', _("cant_picklock_here"), "#f00")
            end
        else
            CallRemoteEvent(player, 'KNotify:Send', _("cant_steal_bars_now"), "#f00")
        end
    end
end)

AddRemoteEvent("OpenThiefMenu", function(player) 
    if PlayerData[player].job == 'thief' then
        CallRemoteEvent(player, "ShowThiefMenu")
    end
end)

AddRemoteEvent("RPNotify:ObjectInteract_bankenter", function(player, object)
    SetPlayerLocation(player, 189784, 201549, 835)
end)

AddRemoteEvent("RPNotify:ObjectInteract_bankleave", function(player, object)
    SetPlayerLocation(player, 191911, 198230, 1309)
end)

AddRemoteEvent("RPNotify:ObjectInteract_trade_silver_bars", function(player, object)
    local total_silver_bars = PlayerData[player]['inventory']['dirty_silver_bar']
    if total_silver_bars ~= nil then
        math.randomseed(os.time())
        random_bar_amount = math.random(150, 400)
        AddBalanceToAccount(player, "cash", random_bar_amount * total_silver_bars)
        RemoveInventory(player, "dirty_silver_bar", total_silver_bars)
        CallRemoteEvent(player, 'KNotify:Send', _("silver_bars_sold"), "#0f0")
    else
        CallRemoteEvent(player, 'KNotify:Send', _("no_bars_to_trade"), "#f00")
    end
end)

AddRemoteEvent("RPNotify:ObjectInteract_stealbars", function(player, object)
    if PlayerData[player].job == "thief" then
        local ox, oy, oz = GetObjectLocation(object)
        local x, y, z = GetPlayerLocation(player)
        if vaultTimer <= 0 then
            if GetDistance3D(x, y, z, ox, oy, oz) <= 250.00 then
                vaultTimer = 300000
                SetPlayerAnimation(player, "PICKUP_MIDDLE")
                Delay(1500, function() 
                    local thief = GetPlayerName(player)
                    math.randomseed(os.time())
                    random_bar_amount = math.random(10, GetPlayerInventorySpace(player))
                    AddPlayerChatAll('<span color="#ff0000">' .. thief .. ' has hit the bank vault. They have stolen ' .. random_bar_amount .. ' silver bars.' .. '</>')
                    AddInventory(player, "dirty_silver_bar", random_bar_amount)
                    CallRemoteEvent(player, 'KNotify:Send', _("stolen_bars"), "#0f0")
                end)
            end
        else
            CallRemoteEvent(player, 'KNotify:Send', _("cant_steal_bars_now"), "#f00")
        end
    else
        CallRemoteEvent(player, 'KNotify:Send', _("not_a_thief"), "#f00")
    end
end)

CreateTimer(function()
    if vaultTimer > 0 then
        vaultTimer = vaultTimer - 1000
    end
end, 1000)


function LockPickAnimation(player)
    SetPlayerAnimation(player, "PICKUP_MIDDLE")
end

function GetNearestDoor(player)
    local x, y, z = GetPlayerLocation(player)
    for k,v in pairs(globaldoors) do
        local x2, y2, z2 = GetDoorLocation(k)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if dist < 500 then
            return k
        end
    end
    return 0
end

AddCommand('obank', function(player) 
    SetPlayerLocation(player, 151589, 203814, 363)
end)
