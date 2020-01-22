local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
AddRemoteEvent("BRPC:FetchPCData", function(player)
    local query = mariadb_prepare(sql, "SELECT * FROM companies where accountid = '?';", PlayerData[player].accountid)
    mariadb_async_query(sql, query, LoadedPlayerCompany, player)
end)

local function GetPlayersInRange(player) 
    local x, y, z = GetPlayerLocation(player)
    local nearestPlayers = GetPlayersInRange3D(x, y, z, 1000)
    local PlayerList = {}
    for k,v in pairs(nearestPlayers) do
        if v ~= player then
            if PlayerData[v] ~= nil then 
                local name = PlayerData[v].name
                if name ~= nil then
                    PlayerList[tostring(v)] = name
                end
            end
        end
    end
    table.insert(PlayerList, {playerid = player, name = PlayerData[player].name})
    playerList[tostring(player)] = PlayerData[player].name
    return playerList
end

function LoadedPlayerCompany(player)
    local PCData = {}
    if mariadb_get_row_count() ~= 0 then
        local company = mariadb_get_assoc(1)
        -- local playersInRange = GetPlayersInRange(player)
        -- PCData['near_players'] = playersInRange
        CompanyDataToObject(PCData, company, player)
        local query = mariadb_prepare(sql, "SELECT accounts.name, accounts.id FROM company_employee LEFT JOIN accounts ON company_employee.account_id = accounts.id WHERE company_id = '?';", company['id'])
        mariadb_async_query(sql, query, LoadedCompanyEmployees, PCData, player)
    end
end

function LoadedCompanyEmployees(PCData, player) 
    PCData['company']['employees'] = {}
    if mariadb_get_row_count() ~= 0 then
        for i=1,mariadb_get_row_count() do
            print("inside loop")
            local employee = mariadb_get_assoc(i)
            table.insert(PCData['company']['employees'], employee)
        end
    end
    CallRemoteEvent(player, "BRPC:Show", json_encode(PCData))
end

function CompanyDataToObject(PCData, company, player)
    PCData['company'] = {
        owner_name = PlayerData[player].name,
        name = company['name'],
        bitcoin_balance = company['bitcoin_balance'],
        upgrades = {}
    }
    table.insert(PCData['company']['upgrades'], 
        { 
            name = "bitcoin_miner",
            available = company['bitcoinminer'],
            friendly_name = _('bitcoin_warehouse') .. " ($500,000)"
        }
    )
end