local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local deliveryNpc = {
            {
                location = { -16925, -29058, 2200, -90 },
                spawn = { -17450, -28600, 2060, -90 }
            },
            {
                location = { -168301, -41499, 1192, 90 },
                spawn = { -168233, -40914, 1146, 90 }
            },
            {
                location = { 202284, 170229, 1306, 0 },
                spawn = { 203032, 170212, 1306, 90 }
            },
            {
                location = { 136696, 210225, 1688, 0 },
                spawn = { 136876, 209815, 1292, 180 }
            },
            {
                location = { 172526, -161539, 1242, 0 },
                spawn = { 173664, -162079, 1244, 90 }
            },
            {
                location = { -182203, -29994, 1148, 90 },
                spawn = { -182659, -29330, 1148, 90 }
            },
            {
                location = { -20649, -30168, 2060, 90 },
                spawn = { -21760, -29723, 2060, 90 }
            },
			-- near 2 garages, fix angle
            {
                location = { 23215, 136181, 1555, 0 },
                spawn = { 24184, 136003, 1555, 90 }
            }
}
local deliveryPoint = {
    { 116691, 164243, 3028 },
    { 38964, 204516, 550 },
    { 182789, 186140, 1203 },
    { 211526, 176056, 1209 },
    { 42323, 137508, 1569 },
    { 122776, 207169, 1282 },
    { 209829, 92977, 1312 },
    { 176840, 10049, 10370 },
    { 198130, -49703, 1109 },
    { 42556, -2071, 9881 },
    { 21489, 11401, 2053 },
    { 130042, 78285, 1566 },
    { 203711, 190025, 1312 },
    { 170311, -161302, 1242 },
	{ 135310, 208181, 1292 },
	{ 140046, 207690, 1292 },
    { 152267, -143379, 1242 },
    { -181677, -31627, 1148 },
    { -179804, -66772, 1147 },
    { 182881, 148416, 5933 },
    { 246, 101628, 1493 },
	{ -182100, -31091, 1148 },
	{ 205827, 170669, 1306 },
	{ 160695, 183345, 1282 }
}

local deliveryNpcCached = {}
local playerDelivery = {}

AddEvent("OnPackageStart", function()
    for k,v in pairs(deliveryNpc) do
        deliveryNpc[k].npc = CreateNPC(deliveryNpc[k].location[1], deliveryNpc[k].location[2], deliveryNpc[k].location[3],deliveryNpc[k].location[4])
        CreateText3D(_("delivery_job").."\n".._("press_e"), 18, deliveryNpc[k].location[1], deliveryNpc[k].location[2], deliveryNpc[k].location[3] + 120, 0, 0, 0)
        table.insert(deliveryNpcCached, deliveryNpc[k].npc)
    end
end)

AddEvent("OnPlayerQuit", function( player )
    if playerDelivery[player] ~= nil then
        playerDelivery[player] = nil
    end
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupDelivery", deliveryNpcCached)
end)

AddRemoteEvent("StartStopDelivery", function(player)
    local nearestDelivery = GetNearestDelivery(player)
    if PlayerData[player].job == "" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
            CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
        else
            local isSpawnable = true
            for k,v in pairs(GetAllVehicles()) do
                local x, y, z = GetVehicleLocation(v)
                local dist2 = GetDistance3D(deliveryNpc[nearestDelivery].spawn[1], deliveryNpc[nearestDelivery].spawn[2], deliveryNpc[nearestDelivery].spawn[3], x, y, z)
                if dist2 < 500.0 then
                    isSpawnable = false
                    break
                end
            end
            if isSpawnable then
                local vehicle = CreateVehicle(24, deliveryNpc[nearestDelivery].spawn[1], deliveryNpc[nearestDelivery].spawn[2], deliveryNpc[nearestDelivery].spawn[3], deliveryNpc[nearestDelivery].spawn[4])
                PlayerData[player].job_vehicle = vehicle
                CreateVehicleData(player, vehicle, 24)
                SetVehiclePropertyValue(vehicle, "locked", true, true)
                PlayerData[player].job = "delivery"
                return
            end
        end
    elseif PlayerData[player].job == "delivery" then
        if PlayerData[player].job_vehicle ~= nil then
            DestroyVehicle(PlayerData[player].job_vehicle)
            DestroyVehicleData(PlayerData[player].job_vehicle)
            PlayerData[player].job_vehicle = nil
        end
        PlayerData[player].job = ""
        playerDelivery[player] = nil
        CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
    end
end)

AddRemoteEvent("OpenDeliveryMenu", function(player)
    if PlayerData[player].job == "delivery" then
        CallRemoteEvent(player, "DeliveryMenu")
    end
end)

AddRemoteEvent("NextDelivery", function(player)
    if playerDelivery[player] ~= nil then
        return CallRemoteEvent(player, "MakeNotification", _("finish_your_delivery"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
    delivery = Random(1, #deliveryPoint)
    playerDelivery[player] = delivery
    CallRemoteEvent(player, "ClientCreateWaypoint", _("delivery"), deliveryPoint[delivery][1], deliveryPoint[delivery][2], deliveryPoint[delivery][3])
    CallRemoteEvent(player, "MakeNotification", _("new_delivery"), "linear-gradient(to right, #00b09b, #96c93d)")
end)

AddRemoteEvent("FinishDelivery", function(player)
    delivery = playerDelivery[player]

    if delivery == nil then
        CallRemoteEvent(player, "MakeNotification", _("no_delivery"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end

    local x, y, z = GetPlayerLocation(player)
    
    local dist = GetDistance3D(x, y, z, deliveryPoint[delivery][1], deliveryPoint[delivery][2], deliveryPoint[delivery][3])

    if dist < 150.0 then
        local reward = Random(1111, 2222)

        CallRemoteEvent(player, "MakeNotification", _("finished_delivery", reward, _("currency")), "linear-gradient(to right, #ff5f6d, #ffc371)")
        
        AddBalanceToAccount(player, "cash", reward)
        playerDelivery[player] = nil
        CallRemoteEvent(player, "ClientDestroyCurrentWaypoint")
    else
        CallRemoteEvent(player, "MakeNotification", _("no_delivery_point"), "linear-gradient(to right, #ff5f6d, #ffc371)")
    end
end)

function GetNearestDelivery(player)
	local x, y, z = GetPlayerLocation(player)
	
	for k,v in pairs(GetAllNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 250.0 then
			for k,i in pairs(deliveryNpc) do
				if v == i.npc then
					return k
				end
			end
		end
	end

	return 0
end