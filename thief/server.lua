local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local EnterBank 
vaultTimer = 0 
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
end)

AddEvent("OnPlayerInteractDoor", function( player, door, bWantsOpen )
    if globaldoors[door] ~= nil and globaldoors[door].locked then
        SetDoorOpen(door, false)
        CallRemoteEvent(player, "MakeNotification", _("vault_locked"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end)

AddRemoteEvent("StartThiefJob", function(player)
    PlayerData[player].job = "thief"
end)

AddRemoteEvent("PickOpenDoor", function(player)
    if PlayerData[player].job == "thief" then
        local nearestdoor = GetNearestDoor(player)
        if globaldoors[nearestdoor] ~= nil then
            LockPickAnimation(player)
            pickanimationtimer = CreateTimer(LockPickAnimation, 2000, player)
            CallRemoteEvent(player, "MakeNotification", _("picking_door"), "linear-gradient(to right, #00b09b, #96c93d)")
            Delay(10000, function() 
                DestroyTimer(pickanimationtimer)
                SetPlayerAnimation(player, "STOP")
                globaldoors[nearestdoor].locked = false
                CallRemoteEvent(player, "MakeNotification", _("door_picklocked"), "linear-gradient(to right, #00b09b, #96c93d)")
            end)
        else
            CallRemoteEvent(player, "MakeNotification", _("cant_picklock_door"), "linear-gradient(to right, #ff5f6d, #ffc371)")
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

AddRemoteEvent("RPNotify:ObjectInteract_stealbars", function(player, object)
    local ox, oy, oz = GetObjectLocation(object)
    local x, y, z = GetPlayerLocation(player)
    if vaultTimer <= 0 then
        if GetDistance3D(x, y, z, ox, oy, oz) <= 250.00 then
            vaultTimer = 600000
            SetPlayerAnimation(player, "PICKUP_MIDDLE")
            Delay(1500, function() 
                local thief = GetPlayerName(player)
                math.randomseed(os.time())
                random_bar_amount = math.random(1, 100)
                AddPlayerChatAll('<span color="#ff0000">' .. thief .. ' has hit the bank vault. They have stolen ' .. random_bar_amount .. ' silver bars.' .. '</>')
                AddInventory(player, "dirty_silver_bar", random_bar_amount)
                CallRemoteEvent(player, "MakeNotification", _("stolen_bars"), "linear-gradient(to right, #00b09b, #96c93d)")
            end)
        end
    else
        CallRemoteEvent(player, "MakeNotification", _("cant_steal_bars_now"), "linear-gradient(to right, #ff5f6d, #ffc371)")
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
        if dist < 250.0 then
            return k
        end
    end
    return 0
end

AddCommand('obank', function(player) 
    SetPlayerLocation(player, 184520, 202885, 158)
end)
