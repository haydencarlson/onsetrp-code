
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local companyNpcLocation = {
    213072, 175185, 1307
}
local companyNpc = nil
local CompanyUpgrades = {
    bitcoinminer = {
        price = 500000,
        notificationText = "Bitcoin Warehouse"
    }
}

AddEvent("PlayerDataLoaded", function(player)
    LookForPlayerCompany(player)
    LookForPlayerCompanyEmployee(player)
end)

function LookForPlayerCompany(player)
    local query = mariadb_prepare(sql, "SELECT * FROM companies WHERE accountid = '?';", PlayerData[player].accountid)
    mariadb_async_query(sql, query, LookedForPlayerCompany, player)
end

function LookedForPlayerCompany(player) 
    if mariadb_get_row_count() ~= 0 then
        local company = mariadb_get_assoc(1)
        PlayerData[player].company = company['id']
        PlayerData[player].company_upgrades['bitcoinminer'] = tonumber(company['bitcoinminer'])
    end
end

function LookForPlayerCompanyEmployee(player)
    local query = mariadb_prepare(sql, "SELECT companies.bitcoin_machines_amount, company_employee.company_id, company_employee.id, company_employee.company_id, company_employee.earn_percentage, companies.bitcoinminer FROM company_employee LEFT JOIN companies ON company_employee.company_id = companies.id WHERE account_id = '?';", PlayerData[player].accountid)
    mariadb_async_query(sql, query, LookedForPlayerCompanyEmployee, player)
end

function LookedForPlayerCompanyEmployee(player)
    if mariadb_get_row_count() ~= 0 then
        local companyEmployee = mariadb_get_assoc(1)
        PlayerData[player].employee = {
            id = companyEmployee['id'],
            company_id = companyEmployee['company_id'],
            employee_earn_percentage = tonumber(companyEmployee['earn_percentage'])
        }
        PlayerData[player].company_bitcoin_machines = tonumber(companyEmployee['bitcoin_machines_amount'])
        PlayerData[player].company_upgrades['bitcoinminer'] = tonumber(companyEmployee['bitcoinminer'])
    end
end

AddRemoteEvent("OpenCompanyMenu", function(player)
    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 1000)
    local playerList = {}
    for k,v in pairs(nearestPlayers) do
        if v ~= player then
            if PlayerData[v] ~= nil then 
                local name = PlayerData[v].name
                if name ~= nil then
                    playerList[tostring(v)] = name
                end
            end
        end
    end
    CallRemoteEvent(player, "ShowCompanyMenu", playerList)
end)

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
    if tonumber(GetPlayerCash(player)) < price then
        return CallRemoteEvent(player, 'KNotify:Send', "You dont have $" .. price, "#f00")
    end

    local query = mariadb_prepare(sql, "UPDATE companies SET ? = 1 where accountid = '?';", upgrade, PlayerData[player].accountid)
    mariadb_async_query(sql, query, UpgradedCompany, player, upgrade, price)
end)

AddRemoteEvent("LeaveCompany", function(player)
    local query = mariadb_prepare(sql, "DELETE from company_employee where account_id = '?';", PlayerData[player].accountid)
    mariadb_query(sql, query)
    CallRemoteEvent(player, 'KNotify:Send', "You have left the company", "#0f0")
end)

AddRemoteEvent("HirePlayer", function(hiringPlayer, employee)
    local query =  mariadb_prepare(sql, "SELECT * from companies where accountid = '?';", PlayerData[hiringPlayer].accountid)
    mariadb_async_query(sql, query, LookupPlayerCompany, hiringPlayer, employee)
end)

AddRemoteEvent("OpenFireMenu", function(player)
    local query = mariadb_prepare(sql, "SELECT * FROM companies WHERE accountid = '?';", PlayerData[player].accountid)
    mariadb_async_query(sql, query, LoadedCompanyForFire, player)
end)

AddRemoteEvent("FirePlayer", function(player, playerToFire)
    local query = mariadb_prepare(sql, "DELETE FROM company_employee where account_id = '?';", playerToFire)
    mariadb_query(sql, query)
    local firedPlayer = FindPlayerByAccountId(playerToFire)
    CallRemoteEvent(player, 'KNotify:Send', "Successfully fired player", "#0f0")
    if firedPlayer then
        PlayerData[firedPlayer].employee = nil
        PlayerData[firedPlayer].employee_earn_percentage = nil
        CallRemoteEvent(firedPlayer, 'KNotify:Send', "You have been fired from the company your were in.", "#0f0")
    end
end)

function LoadedCompanyForFire(player) 
    if mariadb_get_row_count() == 0 then
        CallRemoteEvent(player, 'KNotify:Send', "You dont own a company", "#f00")
    else
        local company = mariadb_get_assoc(1)
        local query = mariadb_prepare(sql, "SELECT * FROM company_employee where company_id = '?';", company['id'])
        mariadb_async_query(sql, query, LoadPlayerListToFire, player)
    end
end

function LoadPlayerListToFire(player)
    local employeeList = ""
    if mariadb_get_row_count() == 0 then
        CallRemoteEvent(player, "ShowFireMenu", {})
    end
    for i=1,mariadb_get_row_count() do
        local employee = mariadb_get_assoc(i)
        if i == mariadb_get_row_count() then
            employeeList = employeeList .. tostring(employee['account_id'])
        else
            employeeList = employeeList .. tostring(employee['account_id'])..','
        end
    end
    local query = mariadb_prepare(sql, "SELECT * FROM accounts where id IN (?);", employeeList)
    mariadb_async_query(sql, query, LoadedCompanyEmployeesById, player)
    
end

function LoadedCompanyEmployeesById(player)
    local employeeList = {}
    for i=1,mariadb_get_row_count() do
        local employee = mariadb_get_assoc(i)
        employeeList[employee['id']] = employee['name']
    end
    CallRemoteEvent(player, "ShowFireMenu", employeeList)
end

function LookupPlayerCompany(hiringPlayer, employee) 
    local company = mariadb_get_assoc(1)
    local query = mariadb_prepare(sql, "SELECT * from companies where accountid = '?';", PlayerData[tonumber(employee)].accountid)
    mariadb_async_query(sql, query, LookHiredPlayerOwnsCompany, hiringPlayer, employee, company['id'], company['name'], company)
end

function LookHiredPlayerOwnsCompany(hiringPlayer, employee, companyId, compsanyName, company) 
    if mariadb_get_row_count() == 0 then
        local query = mariadb_prepare(sql, "SELECT * from company_employee where account_id = '?';", PlayerData[tonumber(employee)].accountid)
        mariadb_async_query(sql, query, LookHiredPlayerIsInCompany, hiringPlayer, employee, companyId, companyName, company)
    else
        CallRemoteEvent(hiringPlayer, 'KNotify:Send', "Player owns there own company", "#f00")
    end
end

function LookHiredPlayerIsInCompany(hiringPlayer, employee, companyId, companyName, company) 
    if mariadb_get_row_count() == 0 then
        local query = mariadb_prepare(sql, "INSERT INTO company_employee (company_id, account_id) VALUES (?, ?);", tostring(companyId), PlayerData[tonumber(employee)].accountid)
        mariadb_async_query(sql, query, InsertedNewEmployee, employee, company)
        CallRemoteEvent(hiringPlayer, 'KNotify:Send', "You have hired " .. PlayerData[tonumber(employee)].name, "#0f0")
        CallRemoteEvent(employee, 'KNotify:Send', companyName .. ' has hired you', "#0f0")
    else
        CallRemoteEvent(hiringPlayer, 'KNotify:Send', "Player is already hired by a company", "#f00")
    end
end

function InsertedNewEmployee(employee, company)
    local insertId = mariadb_get_insert_id()
    PlayerData[tonumber(employee)].employee = {
        id = insertId,
        company_id = company['id'],
        employee_earn_percentage = 0
    }
    PlayerData[tonumber(employee)].company_upgrades['bitcoinminer'] = tonumber(company['bitcoinminer'])
end

local function EmployeesToAddUpgradesTo(player, upgrade)
    for i=1,mariadb_get_row_count() do
        local employee = mariadb_get_assoc(i)
        local playerInGame = FindPlayerByAccountId(employee['account_id'])
        if playerInGame then
            PlayerData[playerInGame].company_upgrades[upgrade] = 1
        end
    end
end

local function AddUpgradeToCompanyPlayerData(player, upgrade)
    PlayerData[player].company_upgrades[upgrade] = 1
    local query = mariadb_prepare(sql, "SELECT * FROM company_employee WHERE company_id = '?';", PlayerData[player].company)
    mariadb_async_query(sql, query, EmployeesToAddUpgradesTo, player)
    
end

function UpgradedCompany(player, upgrade, amount)
    RemoveBalanceFromAccount(player, "cash", amount)
    CallRemoteEvent(player, "BRPC:UpgradedCompany", upgrade)
    AddUpgradeToCompanyPlayerData(player, upgrade)
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
    local insertId = mariadb_get_insert_id()
    PlayerData[tonumber(player)].company = insertId
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