local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
PlayerBitcoinMiners = {}
BitcoinMinerNpcXYZ = { -1414, 141106, 1851 }
BaseBitcoinPerHour = 0.005
BitcoinMinerNpc = nil
local machinePowerTimeSecs = 5
local Machines = {
    {name="Machine 1",x=-1665,y=141383,z=1851},
    {name="Machine 2",x=-1889,y=141383,z=1851},
    {name="Machine 3",x=-2146,y=141383,z=1851},
    {name="Machine 4",x=-2371,y=141383,z=1851},
    {name="Machine 5",x=-2599,y=141383,z=1851},
    {name="Machine 6",x=-2824,y=141383,z=1851},
    {name="Machine 7",x=-3065,y=141383,z=1851},
    {name="Machine 8",x=-3288,y=141383,z=1851},
    {name="Machine 9",x=-3519,y=141383,z=1851},
    {name="Machine 10",x=-3744,y=141383,z=1851},
    {name="Machine 11",x=-3972,y=141383,z=1851}
}


-- MACHINE PAYMENTS
local function TotalBitcoinPay(company, percent, isEmployee)
    local companyMiners = tonumber(company['bitcoin_machines_amount'])
    local extraPercent = percent
    local payAmount
    if isEmployee then
        payAmount = (companyMiners * BaseBitcoinPerHour) * percent
    else
        local extraBitcoin = (companyMiners * BaseBitcoinPerHour) * extraPercent
        payAmount = (companyMiners * BaseBitcoinPerHour) + extraBitcoin
    end
    return payAmount
end

local function PayEmployee(employee, company, employeeEarnPercent)
    local payAmount = TotalBitcoinPay(company, employeeEarnPercent, true)
    local query = mariadb_prepare(sql, "UPDATE company_employee SET bitcoin_balance = bitcoin_balance + '?' WHERE id = '?'", payAmount, employee['id'])
    mariadb_query(sql, query)
end

local function PayCompany(company, employeeExtraPercentage)
    local payAmount = TotalBitcoinPay(company, employeeExtraPercentage, false)
    local query = mariadb_prepare(sql, "UPDATE companies SET bitcoin_balance = bitcoin_balance + '?' WHERE id = '?'", payAmount, company['id'])
    mariadb_query(sql, query)
end

local function LoadedCompanyEmployees(company)
    local employeeExtraPercentage = 0.000
    if mariadb_get_row_count() ~= 0 then
        for i=1,mariadb_get_row_count() do
            local employee = mariadb_get_assoc(i)
            local employeeEarnPercent = tonumber(employee['earn_percentage'])
            employeeExtraPercentage = employeeExtraPercentage + employeeEarnPercent
            PayEmployee(employee, company, employeeEarnPercent)
        end
        PayCompany(company, employeeExtraPercentage)
    else
        PayCompany(company, employeeExtraPercentage)
    end
end

local function LoadedCompanyWithMiners()
    if mariadb_get_row_count() ~= 0 then
        for i=1,mariadb_get_row_count() do
            local company = mariadb_get_assoc(i)
            local query = mariadb_prepare(sql, "SELECT * FROM company_employee WHERE earn_percentage != 0.000 and company_id = '?';", company['id'])
            mariadb_async_query(sql, query, LoadedCompanyEmployees, company)
        end
    end
end

local function PayOutMachines()
    local query = mariadb_prepare(sql, "SELECT * FROM companies WHERE bitcoinminer = 1 and bitcoin_machines_amount != 0;")
    mariadb_async_query(sql, query, LoadedCompanyWithMiners)
end

AddCommand('pay', function()
    CallEvent("ServerTime:OneHourPassed")
end)

AddEvent("ServerTime:OneHourPassed", function()
    PayOutMachines()
end)

-- CODE FOR HANDLING IN GAME MACHINES
AddEvent("OnPackageStart", function()
    CreateText3D("Bitcoin Manager".."\n".._("press_e"), 18, BitcoinMinerNpcXYZ[1], BitcoinMinerNpcXYZ[2], BitcoinMinerNpcXYZ[3] + 120, 0, 0, 0)
    BitcoinMinerNpc = CreateNPC(BitcoinMinerNpcXYZ[1], BitcoinMinerNpcXYZ[2], BitcoinMinerNpcXYZ[3], 180)
    local i = 1
    for _ in pairs(Machines) do
		local obj = CreatePickup(336, Machines[i].x, Machines[i].y, Machines[i].z - 100)
		SetPickupScale(obj, 0.8,0.8,0.5)
		SetPickupPropertyValue(obj, "bitcoin_miner", true, true)
		i = i + 1
	end 
end)

AddRemoteEvent("StartPoweringBitcoinMachine", function(player)
    -- if PlayerData[player].company ~= nil then
    --     return CallRemoteEvent(player, 'KNotify:Send', "Only employees can power the machines", "#f00")
    -- end
    
    if PlayerData[player].employee == nil then
        return CallRemoteEvent(player, 'KNotify:Send', "You dont work for a company", "#f00")
    end
    
    if PlayerData[player].employee ~= nil then
        SetPlayerAnimation(player, "PICKUP_MIDDLE")
        CallRemoteEvent(player, "LockControlMove", true)
        CallRemoteEvent(player, 'KNotify:AddProgressBar', "Powering Machine", machinePowerTimeSecs, "#990000", "powering_bitcoin_machine", true)
        Delay((machinePowerTimeSecs * 1000) + 1000, CompletedPoweringMachine, player)
    end
end)

function CompletedPoweringMachine(player)
    CallRemoteEvent(player, "FinishedPoweringMachine")
    CallRemoteEvent(player, "LockControlMove", false)
    CouldUpdatePlayerPercentage(player)
end

function CouldUpdatePlayerPercentage(player)
    local outcome = Random(0, 1)
    local earnPercentIncrease = 0.001
    if outcome == 1 then
        local query = mariadb_prepare(sql, "UPDATE company_employee set earn_percentage = earn_percentage + ? WHERE id = '?';", earnPercentIncrease, PlayerData[player].employee)
        mariadb_async_query(sql, query, OnUpdatedPlayerEarnPercentage, player, earnPercentIncrease)
    end
end

function OnUpdatedPlayerEarnPercentage(player, earnPercentIncrease)
    local newPercent = tonumber(PlayerData[player].employee_earn_percentage) + earnPercentIncrease
    PlayerData[player].employee_earn_percentage = newPercent
    Delay(3000, function(p, percent)
        CallRemoteEvent(p, 'KNotify:Send', "You now make " .. tostring(newPercent * 100) .. " %% from the company miners", "#0f0")
    end, player, newPercent)
end

AddRemoteEvent("OpenBitcoinWareHouseMenu", function(player)
    if PlayerData[player].company ~= nil then
        return CallRemoteEvent(player, "ShowBitcoinWarehouseCompanyMenu")
    end

    if PlayerData[player].employee ~= nil then
        return CallRemoteEvent(player, 'KNotify:Send', "Only the company owner can buy more machines", "#f00")
    end
end)

AddRemoteEvent("PurchaseBitcoinMachines", function(player, numMachines)
    if PlayerData[player].company ~= nil then
        local numMachines = tonumber(numMachines)
        local cost = 5000 * numMachines
        if numMachines < 1 then
            return CallRemoteEvent(player, 'KNotify:Send', _("no_zero_machines"), "#f00")
        end
        if GetPlayerCash(player) >= cost then
            RemoveBalanceFromAccount(player, "cash", cost)
            AddMachinesToCompany(numMachines, PlayerData[player].company, player)
        else
            return CallRemoteEvent(player, 'KNotify:Send', "You cant afford " .. numMachines .. " for $" .. cost , "#f00")
        end
    else
        return CallRemoteEvent(player, 'KNotify:Send', "Only the company owner can buy more machines", "#f00")
    end
end)

function AddMachinesToCompany(numMachines, company, player)
    local query = mariadb_prepare(sql, "UPDATE companies set bitcoin_machines_amount = bitcoin_machines_amount + 1 WHERE id = '?';", company)
    mariadb_async_query(sql, query, AddedNewMachines, numMachines, player)
end

function AddedNewMachines(numMachines, player)
    CallRemoteEvent(player, 'KNotify:Send', "You have purchased " .. numMachines .. " machine for your company" , "#0f0")
end


AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetupBitcoinMinerGuy", BitcoinMinerNpc)
end)

CreateTimer(function()
    for k,v in pairs(GetAllPlayers()) do
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -3092, 141416, 1856, 1000)
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -1997, 141523, 1851, 1000)
        CallRemoteEvent(v, "CreateSoundIn3D", "client/files/bitcoinminerfan.mp3", -4089, 141463, 1851, 1000)
    end
end, 7500)