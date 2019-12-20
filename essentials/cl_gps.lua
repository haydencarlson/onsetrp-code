local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local gpsmenu
local gpsmain


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


AddEvent("OnTranslationReady", function()
    gpsmain = Dialog.create(_("gps_menu"), nil,"Create waypoint", "Delete waypoint", "Locations", _("cancel"))
    gpsmenu = Dialog.create(_("gps_menu"), nil, _("gps_home"), _("gps_spawn"), _("gps_vg"), _("gps_fuel"), _("gps_vd"), _("cockinbell"), _("gps_bar"), _("gunshop"), _("delivery_job"), _("cancel"))
end)


AddEvent("OnDialogSubmit", function(dialog, button)
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
		if button == 1 then
		local x, y, z = 178804, 196523, 1315 
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Home City")
		end
		
		if button == 2 then
		local x, y, z = 170429, 204185, 1411
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Store")
		end
		
		if button == 3 then
		local x, y, z = 206936, 179139, 1312
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Garage")
		end
		
		if button == 4 then
		local x, y, z = 170389, 206425, 1410
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Gas Station")
		end

		if button == 5 then
		local x, y, z = 207009, 171182, 1330
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Car Dealer")
		end
		
		if button == 6 then
		local x, y, z = 192906, 176674, 1324
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Cock In Bell")
		end
		
		if button == 7 then
		local x, y, z = 49100, 133316, 1578
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Bar")
		end
		
		if button == 8 then
		local x, y, z = 206321, 192627, 1358
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Gun Shop")
		end
		
		if button == 9 then
		local x, y, z = 202381, 170223, 1306
		if currentWaypoint ~= nil then
        	DestroyWaypoint(currentWaypoint)
    		end
		currentWaypoint = CreateWaypoint(x, y, z, "Delivery Job")
		end

		
		if button == 10 then
		end

		
   	 end
end)

AddRemoteEvent("ClientDestroyCurrentWaypoint", function()
    DestroyWaypoint(currentWaypoint)
end)


function OnKeyPress(k)
	if k == "L" then
		DestroyWaypoint(waypointId)
	end
end
AddEvent("OnKeyPress", OnKeyPress)

