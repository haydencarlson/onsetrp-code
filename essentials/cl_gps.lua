local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local gpsmenu
local gpsmain
local teleportPlace = {
	gas_station = { 125773, 80246, 1645 },
	police_station = { 169277, 193489, 1307 },
    town = { -182821, -41675, 1160 },
    prison = { -167958, 78089, 1569 },
    diner = { 212405, 94489, 1340 },
    shopp1 = { 128000, 77622, 1576 },
    shopp2 = { 42600, 137926, 1581 },
    shopp3 = { -15300, -2773, 2065 },
    cockinbell = { 194206, 177201, 1307 },
    bar = { 49100, 133316, 1578 },
    shopp4 = { -169000, -39441, 1149 },
    weed_gather_zone = { 186601, -39031, 1451 },
    weed_process_zone = { 70695, 9566, 1366 },
    heroin_gather_zone = { 186474, -43277, 1451 },
    heroin_process_zone = { 73218, 3822, 1367 },
    meth_gather_zone = { 193607, -46512, 1451 },
    meth_process_zone = { 72095, 1418, 1367 },
    wealthbank = { 211925, 191382, 1306 },
    coke_gather_zone = { 192080, -45155, 1529 },
    coke_process_zone = { 71981, 106, 1367 },
    mining_gather_zone = { 32853, 98521, 1849 },
    mining_process_zone = { 2427, 98041, 1497 },
    mining_sell_zone = { 21799, 137848, 1555 },
    drugs_sell_zone = { -177344, 3673, 1992 },
    home_cardealer = { 207113, 171199, 1330 },
    train_station = { 134704, 209961, 1292 },
	delivery_npc_location = { 202284, 170229, 1306 },
	city_hall = {211882, 175167, 1307}
}

AddEvent("OnKeyPress", function( key )
    if key == "G" then
		if not IsPlayerInVehicle() then
			Dialog.show(gpsmain)
			return 
		end
    end
end)

AddEvent("OnKeyPress", function( key )
    if key == "G" then
		if IsCtrlPressed() and key == 'G' then
			Dialog.show(gpsmain)
			return 
		end
    end
end)

AddRemoteEvent("ClientCreateWaypoint", function(name, x, y, z)
    if currentWaypoint ~= nil then
        DestroyWaypoint(currentWaypoint)
    end
    
    currentWaypoint = CreateWaypoint(tonumber(x), tonumber(y), tonumber(z), tostring(name))    
end)

AddRemoteEvent("ClientDestroyCurrentWaypoint", function()
    DestroyWaypoint(currentWaypoint)
end)

AddEvent("OnTranslationReady", function()
	gpsmain = Dialog.create(_("gps_menu"), nil,"Create waypoint", "Delete waypoint", "Locations", _("cancel"))
	gpsmenu = Dialog.create(_("gps_menu"), nil, _("set_waypoint"), _("cancel"))
	Dialog.addSelect(gpsmenu, 1, _("location"), 8)
	local tpPlace = {}
    for k,v in pairs(teleportPlace) do
        tpPlace[k] = _(k)
	end
	Dialog.setSelectLabeledOptions(gpsmenu, 1, 1, tpPlace)
end)


AddEvent("OnDialogSubmit", function(dialog, button, ...)
	if dialog == gpsmain then
		if button == 1 then
			local x, y, z = GetPlayerLocation()
			if currentWaypoint ~= nil then
			DestroyWaypoint(currentWaypoint)
		end
		currentWaypoint = CreateWaypoint(x, y, z, "Important Location")
	end
	if button == 2 then
		if currentWaypoint ~= nil then
			DestroyWaypoint(currentWaypoint)
		end
	end
	if button == 3 then
		Dialog.show(gpsmenu)
	end
	if button == 4 then
		end
 	end
	if dialog == gpsmenu then
		local args = { ... }
		if button == 1 then
			local chords = teleportPlace[args[1]]
			CreateWaypoint(chords[1], chords[2], chords[3], _(args[1]))
		end
	end
end)

AddRemoteEvent("ClientDestroyCurrentWaypoint", function()
    DestroyWaypoint(currentWaypoint)
end)


function OnKeyPress(k)
	if k == "L" then
		if waypointId ~= nil then
			DestroyWaypoint(waypointId)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

