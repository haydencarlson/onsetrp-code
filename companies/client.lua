local Dialog = ImportPackage("dialogui")
local brpc = ImportPackage("brpc")
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
    createJoinCompany = Dialog.create(_("create_join_company"), nil, _("create_company"), _("cancel"))

    -- Manage Menu
    openPC = Dialog.create(_("manage_your_company"), nil, "Open Computer", _("cancel"))

    -- Create new Company Menu
    createCompany = Dialog.create(_("create_new_company"), nil, _("create_company"), _("cancel"))
    Dialog.addTextInput(createCompany, 1, _("company_name"))

    -- Leave company
    leaveCompany = Dialog.create("Leave Company", nil, _("yes_leave"), _("cancel"))
end)

AddRemoteEvent("ShowCompanyMenu", function(playerList)
    Dialog.setSelectLabeledOptions(hireMenu, 1, 1, playerList)
    Dialog.show(companyMenu)
end)

AddRemoteEvent("ShowFireMenu", function(employeeList)
    Dialog.setSelectLabeledOptions(fireMenu, 1, 1, employeeList)
    Dialog.show(fireMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == fireMenu then
        if button == 1 then
            local employee = args[1]
            if employee == "" then
                CallEvent('KNotify:Send', _("select_a_player"), "#f00")
            else
                CallRemoteEvent("FirePlayer", employee)
            end
        end
    end
    if dialog == hireMenu then
        if button == 1 then
            local player = args[1]
            if player == "" then
                CallEvent('KNotify:Send', _("select_a_player"), "#f00")
            else 
                CallRemoteEvent("HirePlayer", player)
            end
        end
    end
    if dialog == createJoinCompany then
        if button == 1 then
            Dialog.show(createCompany)
        end
    end
    if dialog == openPC then
        if button == 1 then
            CallEvent("BRPC:StartOpen")
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
    if dialog == leaveCompany then
        if button == 1 then
            CallRemoteEvent("LeaveCompany")
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
    Dialog.show(openPC)
end)

AddRemoteEvent("ShowLeaveCompany", function()
    Dialog.show(leaveCompany)
end)
