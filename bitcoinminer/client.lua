local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local buyBitcoinMachineMenu
local nearMachine = false
local poweringMachine = false
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
BitcoinMinerNpcId = nil

local function GetNearestNpc()
	local x, y, z = GetPlayerLocation()
    for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if dist < 250.0 then
            if v == BitcoinMinerNpcId then
                return v
            end
		end
	end
	return 0
end

AddEvent("OnKeyPress", function(key)
    if key == "E" and not onCharacterCreation then
        local NearestNpc = GetNearestNpc()
        if NearestNpc ~= 0 then
            return CallRemoteEvent("OpenBitcoinWareHouseMenu")
        end
    end
    if key == "E" and nearMachine and not poweringMachine then
        poweringMachine = true
        CallRemoteEvent("StartPoweringBitcoinMachine")
    end
end)

AddEvent("OnPackageStart", function()
	LoadPak("gamingcomputer", "/gamingcomputer/", "../../../OnsetModding/Plugins/gamingcomputer/Content")
    ReplaceObjectModelMesh(110, "/gamingcomputer/pc")
    refreshTimer = CreateTimer(CheckBitcoinMiner, 100)
end)

function CheckBitcoinMiner()
    nearMachine = false
	local x,y,z = GetPlayerLocation()
	local distance = 0
    local i = 1
	for _ in pairs(Machines) do
        if GetDistance3D(x,y,z,Machines[i].x, Machines[i].y, Machines[i].z) <= 80 and not UIOpen and not poweringMachine then
            nearMachine = true
            distance = GetDistance3D(x,y,z,Machines[i].x, Machines[i].y, Machines[i].z)
            CallEvent("KNotify:SendPress", "Press [E] to start powering on machine")
        end
		i = i + 1
	end
    if not nearMachine then
		CallEvent("KNotify:HidePress")
	end
end

AddRemoteEvent("FinishedPoweringMachine", function(powered)
    CallEvent('KNotify:RemoveProgressBar', "powering_bitcoin_machine")
    if powered then
        CallEvent('KNotify:Send', "You have powered the machine", "#0f0")
    end
    poweringMachine = false
end)

AddEvent("OnTranslationReady", function()
    buyBitcoinMachineMenu = Dialog.create(_("buy_machines"), nil, _("make_purchase"), _("cancel"))
    Dialog.addTextInput(buyBitcoinMachineMenu, 1, _("machine_amount") .. " ( $5000 each )")
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = { ... }
    if dialog == buyBitcoinMachineMenu then
        if button == 1 then
            if args[1] == "" or tonumber(args[1]) < 0 then
                CallEvent('KNotify:Send', _("no_zero_machines"), "#f00")
            else
                CallRemoteEvent("PurchaseBitcoinMachines", args[1])
            end
        end
    end
end)


AddRemoteEvent("ShowBitcoinWarehouseCompanyMenu", function()
    Dialog.show(buyBitcoinMachineMenu)
end)

AddRemoteEvent("SetupBitcoinMinerGuy", function(npc)
    BitcoinMinerNpcId = npc
end)

AddRemoteEvent("CreateSoundIn3D", function(filename, x, y, z, radius)
    sound = CreateSound3D(filename, x, y, z, radius)
end)
