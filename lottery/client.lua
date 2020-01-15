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
                CallEvent('KNotify:Send', _("lotto_amount"), "#f00")
            else
                CallRemoteEvent("joinLotto", math.floor(args[1]))
            end
        end
    end
end)

AddEvent("OnPackageStart", function(time)
    CreateTimer(function(time)
    local time = GetTime()
    CallRemoteEvent("LotteryPayload", time)
    end, 1000)
end)
