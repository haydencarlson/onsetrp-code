
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local companyNpcLocation = {
    213072, 175185, 1307
}
local companyNpc = nil
local CompanyUpgrades = {
    bitcoinminer = {
        text = "Bitcoin Mining Warehouse ($100,000)",
        price = 100000,
        notificationText = "Bitcoin Warehouse"
    }
}

AddEvent("OnPackageStart", function()
    CreateText3D("Company Manager".."\n".._("press_e"), 18, companyNpcLocation[1], companyNpcLocation[2], companyNpcLocation[3] + 120, 0, 0, 0)
    companyNpc = CreateNPC(companyNpcLocation[1], companyNpcLocation[2], companyNpcLocation[3], 180)
end)


AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "CompanyGuySetup", companyNpc)
end)

AddRemoteEvent("CompanyGuyInteract", function(player)
    local query = mariadb_prepare(sql, "SELECT * FROM companies WHERE accountid = '?';", PlayerData[player].accountid)
    mariadb_async_query(sql, query, LookedUpCompanyByPlayer, player)
end)

AddRemoteEvent("CreateNewCompany", function(player, companyName) 
    local query = mariadb_prepare(sql, "SELECT * FROM companies where name = '?';", companyName)
    mariadb_async_query(sql, query, ExistingCompanyName, companyName, player)
end)

AddRemoteEvent("ManageCompany", function(player) 
    local query = mariadb_prepare(sql, "SELECT * FROM companies WHERE accountid = '?';", PlayerData[player].accountid)
    mariadb_async_query(sql, query, ManagePlayerCompany, player)
end)

AddRemoteEvent("UpgradeCompany", function(player, upgrade)
    local price = CompanyUpgrades[upgrade].price
    if GetPlayerCash(player) < price then
        return CallRemoteEvent(player, 'KNotify:Send', "You dont have $" .. price, "#f00")
    end
    print(upgrade)
    local query = mariadb_prepare(sql, "UPDATE companies SET ? = 1 where accountid = '?';", upgrade, PlayerData[player].accountid)
    mariadb_async_query(sql, query, UpgradedCompany, player, upgrade)
end)


function UpgradedCompany(player, upgrade)
    CallRemoteEvent(player, 'KNotify:Send', "Your company now has access to the " .. CompanyUpgrades[upgrade].notificationText, "#0f0")
end


function ManagePlayerCompany(player)
    if mariadb_get_row_count() == 0 then
        CallRemoteEvent(player, 'KNotify:Send', "You dont have a company", "#f00")
    else
        local company = mariadb_get_assoc(1)
        local upgradesAvailable = nil
        if tonumber(company['bitcoinminer']) == 0 then
            upgradesAvailable = {}
            upgradesAvailable['bitcoinminer'] = CompanyUpgrades['bitcoinminer']['text']
        end
        CallRemoteEvent(player, "ShowUpgradeCompany", upgradesAvailable)
    end
end

function ExistingCompanyName(companyName, player)
    if mariadb_get_row_count() == 0 then
        local query = mariadb_prepare(sql, "INSERT INTO companies (name, accountid) VALUES ('?', '?');", companyName, PlayerData[player].accountid)
        mariadb_async_query(sql, query, CreatedNewCompany, companyName, player)
    else
        CallRemoteEvent(player, 'KNotify:Send', "Company name " .. companyName .. " already exists.", "#f00")
    end
end


function CreatedNewCompany(companyName, player)
    CallRemoteEvent(player, 'KNotify:Send', companyName .. " company has been created.", "#0f0")
end

function LookedUpCompanyByPlayer(player) 
    if mariadb_get_row_count() == 0 then
        local query = mariadb_prepare(sql, "SELECT * FROM company_employee WHERE account_id = '?';", PlayerData[player].accountid)
        mariadb_async_query(sql, query, LookedUpCompanyEmployeeByPlayer, player)
    else
        CallRemoteEvent(player, "ShowManageCompany")
    end
end

function LookedUpCompanyEmployeeByPlayer(player) 
    if mariadb_get_row_count() == 0 then
        CallRemoteEvent(player, "ShowCreateJoinCompany")
    else
        CallRemoteEvent(player, "ShowLeaveCompany")
    end
end