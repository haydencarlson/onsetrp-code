local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local lottomenu
local lottomenumain


AddRemoteEvent("ShowLotteryMenu", function() 
    Dialog.show(lottomenu)
end)

AddEvent("OnTranslationReady", function()
    lottomenu = Dialog.create(_("lottomenu"), nil, _("joinlotto"), _("cancel"))
    Dialog.addTextInput(lottomenu, 1, _("lottonumber"))
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == lottomenu then
		local args = { ... }
        if button == 1 then
            if args[1] == ""  or math.floor(args[1]) < 1 or math.floor(args[1]) > 150 then
                MakeNotification(_("lotto_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("joinLotto", math.floor(args[1]))
            end
        end
    end
end)
