local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local mechanicMenu
AddEvent("OnTranslationReady", function()
    mechanicMenu = Dialog.create(_("mechanic_menu"), nil, _("repair_vehicle"), _("cancel"))
end)


AddRemoteEvent("ShowMechanicMenu", function() 
    Dialog.show(mechanicMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == mechanicMenu then
        if button == 1 then
            CallRemoteEvent("RepairPlayerVehicle")
            return
        end
    end
end)

AddEvent("OnKeyPress", function( key )
    if key == "F3" and not onCharacterCreation then
        CallRemoteEvent("OpenMechanicMenu")
    end
end)