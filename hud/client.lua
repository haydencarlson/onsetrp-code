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
    
    VehicleSpeedHud = CreateTextBox(-15, 260, "Speed", "right" )
    SetTextBoxAnchors(VehicleSpeedHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(VehicleSpeedHud, 1.0, 0.0)
    
    VehicleHealthHud = CreateTextBox(-15, 280, "Health", "right" )
    SetTextBoxAnchors(VehicleHealthHud, 1.0, 0.0, 1.0, 0.0)
	SetTextBoxAlignment(VehicleHealthHud, 1.0, 0.0)

    VehicleFuelHud = CreateTextBox(-15, 300, "Fuel", "right" )
    SetTextBoxAnchors(VehicleFuelHud, 1.0, 0.0, 1.0, 0.0)
    SetTextBoxAlignment(VehicleFuelHud, 1.0, 0.0)

    minimap = CreateWebUI(0, 0, 0, 0, 0, 32)
    SetWebVisibility(minimap, WEB_HITINVISIBLE)
    SetWebAnchors(minimap, 0, 0, 1, 1)
    SetWebAlignment(minimap, 0, 0)
    SetWebURL(minimap, "http://asset/onsetrp/hud/minimap/minimap.html")
    
	ShowHealthHUD(true)
    ShowWeaponHUD(true)
end
AddEvent("OnPackageStart", OnPackageStart)

function updateHud(vehiclefuel)
    if GetPlayerVehicle() ~= 0 then
        SetTextBoxText(VehicleFuelHud, _("fuel")..vehiclefuel)
    else
        SetTextBoxText(VehicleFuelHud, "")
    end 
end
AddRemoteEvent("updateHud", updateHud)

AddEvent("OnGameTick", function()
    if GetPlayerVehicle() ~= 0 then
        vehiclespeed = math.floor(GetVehicleForwardSpeed(GetPlayerVehicle()))
        vehiclehealth = math.floor(GetVehicleHealth(GetPlayerVehicle()))
        SetTextBoxText(VehicleSpeedHud, _("speed")..vehiclespeed.."KM/H")
        SetTextBoxText(VehicleHealthHud, _("vehicle_health")..vehiclehealth)
    end
    -- Speaking icon check
    local player = GetPlayerId()
    --Minimap refresh
    local x, y, z = GetCameraRotation()
    local px,py,pz = GetPlayerLocation()
    ExecuteWebJS(minimap, "SetHUDHeading("..(360-y)..");")
    ExecuteWebJS(minimap, "SetMap("..px..","..py..","..y..");")
end)

function SetHUDMarker(name, h, r, g, b)
    if h == nil then
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\");");
    else
        ExecuteWebJS(minimap, "SetHUDMarker(\""..name.."\", "..h..", "..r..", "..g..", "..b..");");
    end
end

AddRemoteEvent("SetHUDMarker", SetHUDMarker)
