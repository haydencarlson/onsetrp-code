local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local bankVaults = {
    branchbankvault = {
        vaultTimer = 0,
        vaultLockProgress = 0,
        vaultProgressText = nil,
        progressLocation = { 213795.546875, 192394.828125, 1309.1391601563 },
        barsLocation = { 214035.46875, 192979.625, 1200.3317871094 },
        textLocation = { 214105, 192949, 1400 }
    },
    undergroundbankvault = {
        vaultTimer = 0,
        vaultLockProgress = 0,
        vaultProgressText = nil,
        progressLocation = { 185145.328125, 203271.4375, 160.6325378418 },
        barsLocation = { 183977, 202876, 50 },
        textLocation = { 184098, 202955, 260 }
    }
}

AddEvent("OnPackageStart", function()
    bankenterobject = CreateObject(340, 191911, 198230, 1309)
    SetObjectPropertyValue(bankenterobject, "action", "bankenter", true)
    CreateText3D(_("enter_bank").."\n".._("press_e"), 18, 191911, 198230, 1309 + 120, 0, 0, 0)

    bankleaveobject = CreateObject(340, 189914, 201541, 813)
    SetObjectPropertyValue(bankleaveobject, "action", "bankleave", true)
    CreateText3D(_("leave_bank").."\n".._("press_e"), 18, 189914, 201541, 813 + 120, 0, 0, 0)

    bartradernpc = CreateNPC(151589, 203814, 363, 240)
    SetNPCPropertyValue(bartradernpc, "action", "trade_silver_bars", true)
    CreateText3D(_("press_e"), 18, 151584, 203722, 380, 0, 0, 0)
    
    for k, v in pairs(bankVaults) do
        local vault = bankVaults[k]
        local bankbars = CreateObject(1487, vault['barsLocation'][1], vault['barsLocation'][2], vault['barsLocation'][3])
        CreateText3D(_("press_e"), 20, vault['textLocation'][1], vault['textLocation'][2], vault['textLocation'][3], 0, 0, 0)
        SetObjectPropertyValue(bankbars, "action", "stealbars", true)
        SetObjectPropertyValue(bankbars, "vault", k, true)
        vault['vaultProgressText'] = CreateText3D("Picklock Progress: " .. vault['vaultLockProgress'] .. " %", 18, vault['progressLocation'][1], vault['progressLocation'][2], vault['progressLocation'][3], 0, 0, 0)
    end
end)

AddEvent("OnPlayerInteractDoor", function( player, door, bWantsOpen )
    if globaldoors[door] ~= nil and globaldoors[door].locked then
        SetDoorOpen(door, false)
        CallRemoteEvent(player, 'KNotify:Send', _("vault_locked"), "#f00")
    end
end)

function ChangeToThiefClothing(player)
    CallRemoteEvent(player, "SetPlayerClothingToPreset", player, 10)
    for k,v in pairs(GetStreamedPlayersForPlayer(player)) do
        CallRemoteEvent(v, "SetPlayerClothingToPreset", player, 10)
    end
end

AddRemoteEvent("SetupThiefUniformOnStreamIn", function(player, otherplayer)
    if PlayerData[otherplayer] == nil then
        return
    end
    if(PlayerData[otherplayer].job ~= "thief") then
        return
    end
    CallRemoteEvent(player, "SetPlayerClothingToPreset", otherplayer, 10)
end)

AddRemoteEvent("StartThiefJob", function(player)
    PlayerData[player].job = "thief"
    ChangeToThiefClothing(player)
end)

AddRemoteEvent("StopThiefJob", function(player)
    PlayerData[player].job = ""
end)

AddRemoteEvent("PickOpenDoor", function(player)
    if PlayerData[player].job == "thief" and GetPlayerPropertyValue(player, "actionInProgress") == 'false' then
        if GetPlayerEquippedWeapon(player) ~= 0 then
            local nearestdoor = GetNearestDoor(player)
            if globaldoors[nearestdoor] ~= nil then
                local vaultTimer = bankVaults[globaldoors[nearestdoor]['location']]['vaultTimer']
                local vaultLockProgress = bankVaults[globaldoors[nearestdoor]['location']]['vaultLockProgress']
                if vaultTimer <= 0 then
                    if vaultLockProgress == 0 then
                        AddPlayerChatAll('<span color="#ff0000">' .. GetPlayerName(player) .. ' is hitting the bank vault. Stop them from stealing the banks money</>')
                    end
                    SetPlayerPropertyValue(player, 'actionInProgress', 'true', true)
                    LockPickAnimation(player)
                    CallEvent("bankRob", player)
                    if vaultLockProgress + 5 < 100 then
                        Delay(2000, function()
                            bankVaults[globaldoors[nearestdoor]['location']]['vaultLockProgress'] = vaultLockProgress + 5
                            SetText3DText(bankVaults[globaldoors[nearestdoor]['location']]['vaultProgressText'], "Picklock Progress: " .. bankVaults[globaldoors[nearestdoor]['location']]['vaultLockProgress'] .. " %")
                            SetPlayerPropertyValue(player, 'actionInProgress', 'false', true)
                        end)
                    else
                        SetPlayerPropertyValue(player, 'actionInProgress', 'false', true)
                        SetText3DText(bankVaults[globaldoors[nearestdoor]['location']]['vaultProgressText'], "Picklock Progress: 100 %")
                        globaldoors[nearestdoor].locked = false
                        SetDoorOpen(nearestdoor, true)
                        CallRemoteEvent(player, 'KNotify:Send', _("door_picklocked"), "#0f0")
                        Delay(60000, function()
                            SetText3DText(bankVaults[globaldoors[nearestdoor]['location']]['vaultProgressText'], "Picklock Progress: 0 %")
                            bankVaults[globaldoors[nearestdoor]['location']]['vaultLockProgress'] = 0
                            if IsDoorOpen(nearestdoor) then
                                SetDoorOpen(nearestdoor, false)
                            end
                            globaldoors[nearestdoor].locked = true
                        end)
                    end
                else
                    CallRemoteEvent(player, 'KNotify:Send', _("cant_steal_bars_now"), "#f00")
                end
            else
                CallRemoteEvent(player, 'KNotify:Send', _("cant_picklock_here"), "#f00")
            end
        else
            CallRemoteEvent(player, 'KNotify:Send', "You need a weapon", "#f00")
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
        random_bar_amount = math.random(100, 250)
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
        local vaultName = GetObjectPropertyValue(object, "vault")
        local vaultTimer = bankVaults[vaultName]['vaultTimer']
        
        if vaultTimer <= 0 then
            if GetDistance3D(x, y, z, ox, oy, oz) <= 250.00 then
                bankVaults[vaultName]['vaultTimer'] = 600000
                SetPlayerAnimation(player, "PICKUP_MIDDLE")
                Delay(1500, function() 
                    local thief = GetPlayerName(player)
                    math.randomseed(os.time())
                    local playerInvSpace = GetPlayerInventorySpace(player)
                    minimumBars = 10
                    if playerInvSpace < 10 then
                        minimumBars = 1
                    end
                    random_bar_amount = math.random(minimumBars, GetPlayerInventorySpace(player))
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
    for k, v in pairs(bankVaults) do
        local timer =  bankVaults[k]['vaultTimer']
        if timer > 0 then
            bankVaults[k]['vaultTimer'] = bankVaults[k]['vaultTimer'] - 1000
        end
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