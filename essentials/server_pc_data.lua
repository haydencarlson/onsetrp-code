local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local function GetPlayersInRange(player) 
    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 1000)
    local PlayerList = {}
    for k,v in pairs(nearestPlayers) do
        -- if v ~= player then
            if PlayerData[v] ~= nil then 
                local name = PlayerData[v].name
                if name ~= nil then
                    table.insert(PlayerList, { name = name, id = v})
                end
            end
        -- end
    end
    return PlayerList
end


local function LoadedCompanyEmployees(PCData, player) 
    PCData['company']['employees'] = {}
    if mariadb_get_row_count() ~= 0 then
        for i=1,mariadb_get_row_count() do
            local employee = mariadb_get_assoc(i)
            if PlayerData[player].employee ~= nil then
                if tostring(employee['id']) == tostring(PlayerData[player].accountid) then
                    PCData['company']['bitcoin_total_earnings'] = employee['total_bitcoin_earnings']
                    PCData['company']['bitcoin_balance'] = employee['bitcoin_balance']
                end
            end
            table.insert(PCData['company']['employees'], employee)
        end
    end
    if PlayerData[player].employee ~= nil then
        PCData['company']['employee_id'] = PlayerData[player].employee['id']
    end
    PCData['company']['company_id'] = PlayerData[player].company
    CallRemoteEvent(player, "BRPC:Show", json_encode(PCData))
end

local function CompanyDataToObject(PCData, company, player)
    PCData['company'] = {
        owner_name = PlayerData[player].name,
        name = company['name'],
        bitcoin_balance = company['bitcoin_balance'],
        upgrades = {}
    }

    if PlayerData[player].company ~= nil then
        PCData['company']['bitcoin_total_earnings'] = company['total_bitcoin_earnings']
        PCData['company']['bitcoin_balance'] = company['bitcoin_balance']
    end
    table.insert(PCData['company']['upgrades'], 
        { 
            name = "bitcoinminer",
            available = company['bitcoinminer'],
            friendly_name = _('bitcoin_warehouse') .. " ($500,000)"
        }
    )
end

local function LoadedPlayerCompany(player)
    local PCData = {}
    if mariadb_get_row_count() ~= 0 then
        local company = mariadb_get_assoc(1)
        local playersInRange = GetPlayersInRange(player)
        PCData['near_players'] = playersInRange
        CompanyDataToObject(PCData, company, player)
        local query = mariadb_prepare(sql, "SELECT accounts.name, company_employee.bitcoin_balance, accounts.id, company_employee.earn_percentage, company_employee.total_bitcoin_earnings FROM company_employee LEFT JOIN accounts ON company_employee.account_id = accounts.id WHERE company_id = '?';", company['id'])
        mariadb_async_query(sql, query, LoadedCompanyEmployees, PCData, player)
    end
end

AddRemoteEvent("BRPC:FetchPCData", function(player)
    local query
    if PlayerData[player].employee == nil and PlayerData[player].company == nil then
        -- Default return when they dont have a company or arent an employee
        PCData = {
            company = {
                employee_id = nil,
                company_id = nil
            }
        }
        return CallRemoteEvent(player, "BRPC:Show", json_encode(PCData))
    end

    if PlayerData[player].employee ~= nil then
        query = mariadb_prepare(sql, "SELECT * FROM companies where id = '?';", PlayerData[player].employee['company_id'])
    else 
        query = mariadb_prepare(sql, "SELECT * FROM companies where accountid = '?';", PlayerData[player].accountid)
    end
    mariadb_async_query(sql, query, LoadedPlayerCompany, player)
end)