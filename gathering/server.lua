local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

gatherTable = {
    {
        gather_zone = { 186601, -39031, 1451 },
        gather_item = "unprocessed_weed",
        process_zone = { 70695, 9566, 1366 },
        process_item = "processed_weed"
    },
    {
        gather_zone = { 215372, 170553, 1305 },
        gather_item = "unprocessed_weed",
        process_zone = { 216992, 170558, 1305 },
        process_item = "processed_weed"
    },
    {
        gather_zone = { 179150, 10368, 10370 },
        gather_item = "unprocessed_weed",
        process_zone = { 178500, 10368, 10370 },
        process_item = "processed_weed"
    },
    {
        gather_zone = { 186000, -43277, 1451 },
        gather_item = "unprocessed_heroin",
        process_zone = { 186474, -43277, 1451 },
        process_item = "processed_heroin"
    },
    {
        gather_zone = { 192902, -48219, 1443 },
        gather_item = "unprocessed_meth",
        process_zone = { 193607, -46512, 1451 },
        process_item = "processed_meth"
    },
	{
        gather_zone = { 99086, 121850, 6460 },
        gather_item = "unprocessed_meth",
        process_zone = { 97196, 117629, 6418 },
        process_item = "processed_meth"
    },
    {
        gather_zone = { 192080, -45155, 1529 },
        gather_item = "unprocessed_coke",
        process_zone = { 71981, 106, 1367 },
        process_item = "processed_coke"
    },
    {
        gather_zone = { 112048, 166191, 2775 },
        gather_item = "unprocessed_coke",
        process_zone = { 114610, 165476, 3028 },
        process_item = "processed_coke"
    },
    {
        gather_zone = { 211220, 206478, 1297 },
        gather_item = "unprocessed_rock",
        gather_tool = "pickaxe",
        process_zone = { 209483, 207916, 1283 },
        process_item = "processed_rock"
    },
    {
        gather_zone = { 181257, 222843, 675 },
        gather_item = "unprocessed_rock",
        gather_tool = "pickaxe",
        process_zone = { 182051, 227958, 117 },
        process_item = "processed_rock"
    },
    {
        gather_zone = { 110192, 131749, 5305 },
        gather_item = "unprocessed_rock",
        gather_tool = "pickaxe",
        process_zone = { 109786, 129557, 5722 },
        process_item = "processed_rock"
    },
    {
        gather_zone = { -96766, 88886, 180 },
        gather_item = "unprocessed_rock",
        gather_tool = "pickaxe",
        process_zone = { -82629, 90991, 481 },
        process_item = "processed_rock"
    },
    {
        gather_zone = { 232464, 193521, 112 },
        gather_item = "fish",
        gather_tool = "fishing_rod",
    },
    {
        gather_zone = { 187378, 146733, 5969 },
        gather_item = "peach",
        pickup_animation = "PICKUP_UPPER"
    }
}

gatherZoneCached = {}
processZoneCached = {}

AddEvent("OnPackageStart", function()
    for k,v in pairs(gatherTable) do
        if v.gather_zone ~= nil then
            v.gatherObject = CreatePickup(2, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3])
            CreateText3D(_("gather").."\n".._("press_e"), 18, v.gather_zone[1], v.gather_zone[2], v.gather_zone[3] + 120, 0, 0, 0)
            table.insert(gatherZoneCached, v.gatherObject)
        end
        
        if v.process_zone ~= nil then
            v.processObject = CreatePickup(2, v.process_zone[1], v.process_zone[2], v.process_zone[3])
            CreateText3D(_("process").."\n".._("press_e"), 18, v.process_zone[1], v.process_zone[2], v.process_zone[3] + 120, 0, 0, 0)
            table.insert(processZoneCached, v.processObject)
        end
	end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "gatheringSetup", gatherZoneCached, processZoneCached)
end)

AddRemoteEvent("StartGathering", function(player, gatherzone) 
    local gather = GetGatherByGatherzone(gatherzone)
    local animation = ""
    local attached_item = 0
    if GetPlayerInventorySpace(player) == 0 then
        return CallRemoteEvent(player, "MakeNotification", _("inventory_not_enough_space"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
    if gatherTable[gather].gather_tool ~= nil then
        if PlayerData[player].inventory[gatherTable[gather].gather_tool] == nil then
            return CallRemoteEvent(player, "MakeNotification", _("need_tool"), "linear-gradient(to right, #ff5f6d, #ffc371)")
        end
    end
    if GetPlayerVehicle(player) ~= 0 then
        return
    end
    if gatherTable[gather].gather_tool == "pickaxe" then
        animation = "PICKAXE_SWING"
        attached_item = 1063
    elseif gatherTable[gather].gather_tool == "fishing_rod" then
        animation = "FISHING"
        attached_item = 1111
    end

    if gatherTable[gather].pickup_animation ~= nil then
        animation = gatherTable[gather].pickup_animation
    else
        animation = "PICKUP_LOWER"
    end
    function DoGathering(player, animation, gather, attached_item)
        if GetPlayerPropertyValue(player, 'actionInProgress') == 'false' then
            SetPlayerPropertyValue(player, 'actionInProgress', 'true', true)
            if gatherTable[gather].process_item == "processed_meth" or gatherTable[gather].process_item == "processed_coke" or gatherTable[gather].process_item == "processed_heroin" or gatherTable[gather].process_item == "processed_weed" then
                CallEvent("makeWanted", player)
            end 
            CallRemoteEvent(player, "LockControlMove", true)
            PlayerData[player].isActioned = true
            SetPlayerAnimation(player, animation)
            SetAttachedItem(player, "hand_r", attached_item)
            Delay(4000, function() 
                SetPlayerAnimation(player, animation)
            end)
            Delay(8000, function()
                SetPlayerPropertyValue(player, "actionInProgress", 'false', true)
                AddInventory(player, gatherTable[gather].gather_item, 1)
                CallRemoteEvent(player, "MakeNotification", _("gather_success", _(gatherTable[gather].gather_item)), "linear-gradient(to right, #00b09b, #96c93d)")
                SetPlayerAnimation(player, "STOP")
                CallRemoteEvent(player, "LockControlMove", false)
                SetAttachedItem(player, "hand_r", 0)
            end)
        end
    end  
    DoGathering(player, animation, gather, attached_item)
end)

AddRemoteEvent("StartProcessing", function(player, processzone) 
    gather = GetGatherByProcesszone(processzone)
    unprocessed_item = gatherTable[gather].gather_item
    if GetPlayerVehicle(player) ~= 0 then
        return
    end
    function DoProcessing(player, gather, unprocessed_item)
        if GetPlayerPropertyValue(player, 'actionInProgress') == 'false' then
            SetPlayerPropertyValue(player, 'actionInProgress', 'true', true)
            if PlayerData[player].inventory[unprocessed_item] == nil then	
                SetPlayerPropertyValue(player, 'actionInProgress', 'false', true)
                return CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")	
            end
            if tonumber(PlayerData[player].inventory[unprocessed_item]) < 1 then
                SetPlayerPropertyValue(player, 'actionInProgress', 'false', true)
                return CallRemoteEvent(player, "MakeNotification", _("not_enough_item"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent(player, "LockControlMove", true)
                RemoveInventory(player, unprocessed_item, 1)
                SetPlayerAnimation(player, "COMBINE")
                Delay(4000, function() 
                    SetPlayerAnimation(player, "COMBINE")
                end)
                Delay(8000, function()
                    SetPlayerPropertyValue(player, "actionInProgress", 'false', true)
                    AddInventory(player, gatherTable[gather].process_item, 1)
                    CallRemoteEvent(player, "MakeNotification", _("process_success", _(gatherTable[gather].process_item)), "linear-gradient(to right, #00b09b, #96c93d)")
                    CallRemoteEvent(player, "LockControlMove", false)
                    SetPlayerAnimation(player, "STOP")
                end)
            end 
        end
    end
    DoProcessing(player, gather, unprocessed_item)
end)

function GetGatherByGatherzone(gatherzone)
    for k,v in pairs(gatherTable) do
        if v.gatherObject == gatherzone then
            return k
        end
    end
end

function GetGatherByProcesszone(processzone)
    for k,v in pairs(gatherTable) do
        if v.processObject == processzone then
            return k
        end
    end
end

