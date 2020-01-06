local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local lottomenu
local lottomenumain

AddEvent("OnTranslationReady", function()
    lottomenu = Dialog.create(_("lottomenu"), nil, _("joinlotto"), _("cancel"))
    Dialog.addTextInput(lottomenu, 1, _("lottonumber"))
end)

AddEvent("OnDialogSubmit", function(dialog, button, ..., player)
    if dialog == lottomenu then
		local args = { ... }
		if button == 1 then
            if args[1] == ""  or math.floor(args[1]) < 1 or math.floor(args[1]) > 150 then
                MakeNotification(_("lotto_amount"), "linear-gradient(to right, #ff5f6d, #ffc371)")
            else
                CallRemoteEvent("joinLotto", player, math.floor(args[1]))
		end
    end
        if button == 2 then 
        end
    end
end)

function OnKeyPress(key)
	if key == "H" then
		print("key pressed")
		Dialog.show(lottomenu)
	end
end
AddEvent("OnKeyPress", OnKeyPress)
