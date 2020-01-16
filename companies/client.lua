local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local companyNpc = nil
local createJoinCompany = nil
local createCompany = nil
local CUI = ImportPackage("cinematicui")

local function GetNearestNpc()
	local x, y, z = GetPlayerLocation()
    for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if dist < 250.0 then
            if v == companyNpc then
                return v
            end
		end
	end
	return 0
end

AddEvent("OnTranslationReady", function()
    -- Create or Join Menu
    createJoinCompany = Dialog.create(_("create_join_company"), nil, _("create_company"),_("join_company"), _("cancel"))

    -- Upgrade Menu
    upgradeCompany = Dialog.create(_("upgrade_company"), nil, _("purchase_company_upgrade"),_("cancel"))
    Dialog.addSelect(upgradeCompany, 1, _("company_upgrades_available"), 5)

    -- Manage Menu
    manageCompany = Dialog.create(_("manage_your_company"), nil, _("upgrade_company"),_("company_employee_request"), _("cancel"))

    -- Create new Company Menu
    createCompany = Dialog.create(_("create_new_company"), nil, _("create_company"), _("cancel"))
    Dialog.addTextInput(createCompany, 1, _("company_name"))
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == createJoinCompany then
        if button == 1 then
            Dialog.show(createCompany)
        end
    end
    if dialog == manageCompany then
        if button == 1 then
            CallRemoteEvent("ManageCompany")
        end
    end
    if dialog == createCompany then
        if button == 1 then
            if args[1] == ""  then
                CallEvent('KNotify:Send', _("company_name_blank"), "#f00")
                Dialog.show(createCompany)
            else
                CallRemoteEvent("CreateNewCompany", args[1])
            end
        end
    end
    if dialog == upgradeCompany then
        local upgrade = args[1]
        if upgrade == "" then
            CallEvent('KNotify:Send', _("choose_company_upgrade"), "#f00")
        else
            CallRemoteEvent("UpgradeCompany", upgrade)
        end
    end
end)

AddEvent("OnKeyPress", function(key)
    if key == "E" and not onCharacterCreation then
        local NearestNpc = GetNearestNpc()
        if NearestNpc ~= 0 then
            CUI.startCinematic(cinematicUIConfig['company'], NearestNpc)
        end
    end
end)

AddEvent("ContinueCompanyInteract", function()
    CallRemoteEvent("CompanyGuyInteract")
end)

AddRemoteEvent("CompanyGuySetup", function(npcId)
    companyNpc = npcId
end)

AddRemoteEvent("ShowCreateJoinCompany", function() 
    Dialog.show(createJoinCompany)
end)

AddRemoteEvent("ShowManageCompany", function()
    Dialog.show(manageCompany)
end)

AddRemoteEvent("ShowUpgradeCompany", function(upgradesAvailable)
    if upgradesAvailable == nil then
        return CallEvent('KNotify:Send', _("company_all_upgrades_done"), "#f00")
    end
    Dialog.setSelectLabeledOptions(upgradeCompany, 1, 1, upgradesAvailable)
    Dialog.show(upgradeCompany)
end)