local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local HungerFoodHud
local ThirstHud
local HealthHud
local VehicleSpeedHud
local VehicleFuelHud
local VehicleHealthHud
local WantedHud
local minimap

function OnPackageStart()
    HealthHud = CreateWebUI(0, 0, 0, 0, 0, 28)
	SetWebAlignment(HealthHud, 1.0, 0.0)
	SetWebAnchors(HealthHud, 0.0, 0.0, 1.0, 1.0) 
	LoadWebFile(HealthHud, "http://asset/onsetrp/hud/health/health.html")
    SetWebVisibility(HealthHud, WEB_HIDDEN)
    
    VehicleSpeedHud = CreateTextBox(-15, 260, "", "right" )
    SetTextBoxAnchors(VehicleSpeedHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(VehicleSpeedHud, 1.0, 0.0)
    
    VehicleHealthHud = CreateTextBox(-15, 280, "", "right" )
    SetTextBoxAnchors(VehicleHealthHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(VehicleHealthHud, 1.0, 0.0)

    VehicleFuelHud = CreateTextBox(-15, 300, "", "right" )
    SetTextBoxAnchors(VehicleFuelHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(VehicleFuelHud, 1.0, 0.0)

	ShowHealthHUD(true)
    ShowWeaponHUD(true)
end
AddEvent("OnPackageStart", OnPackageStart)

function updateHud(vehiclefuel)
    if GetPlayerVehicle() ~= 0 and IsPlayerInVehicle() then
        SetTextBoxText(VehicleFuelHud, _("fuel")..vehiclefuel)
    else
        SetTextBoxText(VehicleFuelHud, "")
    end 
end
AddRemoteEvent("updateHud", updateHud)


AddEvent("OnPlayerLeaveVehicle", function(player, vehicle, seat) 
    SetTextBoxText(VehicleSpeedHud, "")
    SetTextBoxText(VehicleHealthHud, "")
    SetTextBoxText(VehicleFuelHud, "")
end)

AddEvent("OnGameTick", function()
    if GetPlayerVehicle() ~= 0 and IsPlayerInVehicle() then
        vehiclespeed = math.floor(GetVehicleForwardSpeed(GetPlayerVehicle()))
        vehiclehealth = math.floor(GetVehicleHealth(GetPlayerVehicle()))
        SetTextBoxText(VehicleSpeedHud, _("speed")..vehiclespeed.."KM/H")
        SetTextBoxText(VehicleHealthHud, _("vehicle_health")..vehiclehealth)
    end
end)

AddRemoteEvent("SetHUDMarker", SetHUDMarker)

function hideRPHud()
    SetWebVisibility(HungerFoodHud, WEB_HIDDEN)
    SetWebVisibility(ThirstHud, WEB_HIDDEN)
    SetWebVisibility(HealthHud, WEB_HIDDEN)
    SetWebVisibility(SpeakingHud, WEB_HIDDEN)
end

function showRPHud()
    SetWebVisibility(HungerFoodHud, WEB_HITINVISIBLE)
    SetWebVisibility(ThirstHud, WEB_HITINVISIBLE)
    SetWebVisibility(HealthHud, WEB_HITINVISIBLE)
    SetWebVisibility(SpeakingHud, WEB_HITINVISIBLE)
end

AddFunctionExport("hideRPHud", hideRPHud)
AddFunctionExport("showRPHud", showRPHud)
