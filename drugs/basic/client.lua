AddRemoteEvent("Kuzkay:PlantsRemoveLeaves", function(object, slot)
	slot = tonumber(slot)

	local SkeletalMeshComponent = GetObjectStaticMeshComponent(object)
	SkeletalMeshComponent:SetMaterial(slot, UMaterialInterface.LoadFromAsset("/Game/Scripting/Materials/MI_TranslucentLit"))
	local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(slot)
	DynamicMaterialInstance:SetColorParameter("BaseColor", FLinearColor(0.0, 0.0, 0.0, 0.0))
end)

local ui = 0
local drug = nil

function CreateUI(drug_)
	ui = CreateWebUI(0, 0, 0, 0, 5, 50)
	LoadWebFile(ui, "http://asset/onsetrp/drugs/gui/gui.html")
	SetWebAlignment(ui, 0.0, 0.0)
	SetWebAnchors(ui, 0.0, 0.0, 1.0, 1.0)
	
	drug = drug_
end

AddEvent("OnWebLoadComplete", function(web)
	if web == ui and drug ~= nil then
		ExecuteWebJS(ui, "StartProduction('"..drug.."');")
		SetWebVisibility(ui, WEB_VISIBLE)
	end
end)

function DestroyUI()
	DestroyWebUI(ui)
	ui = 0
	Delay(50,function()
		ShowMouseCursor(false)
		SetInputMode(INPUT_GAME)
		SetIgnoreLookInput(false)
		SetIgnoreMoveInput(false)
	end)
	
end

function ToggleUI(drug_)
	if drug ~= drug_ then
		if ui ~= 0 then
			DestroyWebUI(ui)
			ui = 0
		end
	end
	if ui ~= 0 then
		if GetWebVisibility(ui) == WEB_VISIBLE then
			SetWebVisibility(ui, WEB_HIDDEN)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
			SetIgnoreLookInput(false)
			SetIgnoreMoveInput(false)
		else
			SetWebVisibility(ui, WEB_VISIBLE)
			ShowMouseCursor(true)
			SetInputMode(INPUT_GAMEANDUI)
			SetIgnoreLookInput(true)
			SetIgnoreMoveInput(true)
		end	
	else
		CreateUI(drug_)
		ShowMouseCursor(true)
		SetInputMode(INPUT_GAMEANDUI)
		SetIgnoreLookInput(true)
		SetIgnoreMoveInput(true)
	end
end

AddEvent("OnKeyPress", function(key)
	if key == "Escape" then
		if GetWebVisibility(ui) == WEB_VISIBLE then
			SetWebVisibility(ui, WEB_HIDDEN)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
			SetIgnoreLookInput(false)
			SetIgnoreMoveInput(false)
		end
	end
end)



AddRemoteEvent("Kuzkay:OpenDrugLab", function(drug)
	ToggleUI(drug)
end)

AddRemoteEvent("Kuzkay:DrugsStartProduction", function(prodType)
	ExecuteWebJS(ui, "AppendItem('"..prodType.."');")
end)

AddEvent("Kuzkay:DrugsAddItem", function(prodType)
	CallRemoteEvent("Kuzkay:DrugsStartProduction", prodType)
end)

AddEvent("Kuzkay:DrugsAddAddon", function(addType)
	CallRemoteEvent("Kuzkay:DrugsAddAddon", addType)
end)

AddEvent("Kuzkay:DrugsSoakItem", function(liquid)
	CallRemoteEvent("Kuzkay:DrugsSoakItem", liquid)
end)

AddRemoteEvent("Kuzkay:DrugsSetSoakedItem", function(liquid)
	ExecuteWebJS(ui, "SetItemWet('"..liquid.."');")
	ExecuteWebJS(ui, "FreezeDraggable('enable');")
end)

AddRemoteEvent("Kuzkay:DrugsAppendAddon", function(addType)
	ExecuteWebJS(ui, "AppendAddon('"..addType.."');")
end)

AddEvent("Kuzkay:DrugsStartDry", function()
	CallRemoteEvent("Kuzkay:DrugsDry")
end)

AddRemoteEvent("Kuzkay:DrugsDried", function()
	ExecuteWebJS(ui, "DryItem();")
	ExecuteWebJS(ui, "FreezeDraggable('enable');")
end)

AddRemoteEvent("Kuzkay:DrugsFry", function()
	ExecuteWebJS(ui, "FryItem();")
	ExecuteWebJS(ui, "FreezeDraggable('enable');")
end)

AddEvent("Kuzkay:DrugsOnCrush", function()
	CallRemoteEvent("Kuzkay:DrugsCrush")
	ExecuteWebJS(ui, "FreezeDraggable('enable');")
end)

AddRemoteEvent("Kuzkay:DrugsCrush", function(crushType)
	ExecuteWebJS(ui, "CrushItem('"..crushType.."');")
	ExecuteWebJS(ui, "FreezeDraggable('enable');")
end)

AddEvent("Kuzkay:DrugsCollect", function()
	CallRemoteEvent("Kuzkay:DrugsCollect")
end)

AddRemoteEvent("Kuzkay:DrugsFinish", function()
	DestroyUI()
end)

AddEvent("Kuzkay:DrugsRestartProduction", function()
	CallRemoteEvent("Kuzkay:DrugsRestartProduction")
end)

AddRemoteEvent("Kuzkay:DrugsRestarted", function(drug)
	DestroyUI()
	Delay(100, function()
		ToggleUI(drug)
	end)
end)

AddRemoteEvent("Kuzkay:DrugsFreezeDraggable", function()
	ExecuteWebJS(ui, "FreezeDraggable('disable');")
end)
