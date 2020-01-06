local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local mechanicMenu
local vehicleModMenu
local vehicleColorSelectMenu
local vehicleColors = {
    black = 'Black',
    red = 'Red',
    matallic = 'Matallic',
    electric_green = 'Electric Green',
    orange = 'Orange',
    yellow = 'Yellow',
    blue = 'Blue',
    baby_blue = 'Baby Blue',
    dark_purple = 'Dark Purple',
    white = 'White',
    light_purple = 'Light Purple',
    dark_red = 'Dark Red',
    pink = 'Pink'
}
AddEvent("OnTranslationReady", function()
    vehicleColorSelectMenu = Dialog.create("Vehicle Color", nil, "Choose Color", _("cancel"))
    Dialog.addSelect(vehicleColorSelectMenu, 1, "Colors", 10)
    vehicleModMenu = Dialog.create("Vehicle Mods", nil, "Vehicle Color ($1,000)", "Add NOS ($20,000)", "Vehicle Durability ($5,000)",  _("cancel"))
    mechanicMenu = Dialog.create(_("mechanic_menu"), nil, _("repair_vehicle"), _("cancel"))
end)


AddRemoteEvent("ShowMechanicMenu", function() 
    Dialog.show(mechanicMenu)
end)

AddRemoteEvent("ShowVehicleModMenu", function()
    Dialog.show(vehicleModMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == mechanicMenu then
        if button == 1 then
            CallRemoteEvent("RepairPlayerVehicle")
            return
        end
    end
    if dialog == vehicleColorSelectMenu then
        local args = { ... }
        if button == 1 then
            CallRemoteEvent("ApplyVehicleMod", "vehicle_color", args[1])
        end
    end
    if dialog == vehicleModMenu then
        if button == 1 then
            ShowColorSelect()
        end
        if button == 2 then
            CallRemoteEvent("ApplyVehicleMod", "vehicle_nos")
        end
        if button == 3 then
            CallRemoteEvent("ApplyVehicleMod", "vehicle_durability")
        end
    end
end)

function ShowColorSelect()
    Dialog.setSelectLabeledOptions(vehicleColorSelectMenu, 1, 1, vehicleColors)
    Dialog.show(vehicleColorSelectMenu)
end

AddEvent("OnKeyPress", function( key )
    if key == "F3" and not onCharacterCreation then
        CallRemoteEvent("OpenMechanicMenu")
    end
end)