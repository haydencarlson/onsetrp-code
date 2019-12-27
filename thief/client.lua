local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local thiefMenu
AddEvent("OnTranslationReady", function()
    thiefMenu = Dialog.create(_("thief_menu"), nil, _("picklock") ,_("cancel"))
end)

AddRemoteEvent("ShowThiefMenu", function()
    Dialog.show(thiefMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == thiefMenu then
        if button == 1 then
            CallRemoteEvent("PickOpenDoor")
            return
        end
    end
end)

AddEvent("OnKeyPress", function( key )
    if key == "F3" and not onCharacterCreation then
        CallRemoteEvent("OpenThiefMenu")
    end
end)