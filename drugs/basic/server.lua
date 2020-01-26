local dealer = {}

function OnPackageStart()
	Delay(500, function()

		for k,v in pairs(GetAllNPC()) do
			if GetNPCPropertyValue(v, "drug_dealer") ~= nil then
				DestroyNPC(v)
			end
		end
		CreatePlants()
		CreateLabs()
	end)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()
	for k,v in pairs(plants) do
		DestroyObject(v.object)
	end
	for k,v in pairs(DrugStation) do
		DestroyPickup(v.object)
	end
end
AddEvent("OnPackageStop", OnPackageStop)

function CreateDealer()
	local rnd = math.random(1, #DealerLocations)
	local loc = DealerLocations[rnd]
	dealer.loc = loc
	dealer.npc = CreateNPC(loc.x,loc.y,loc.z,loc.h)
	SetNPCPropertyValue(dealer.npc, "drug_dealer", true, true)
	SetNPCPropertyValue(dealer.npc, 'model', 11)
	SetNPCPropertyValue(dealer.npc, "dealer_text", loc.location)
	SetNPCAnimation(dealer.npc, loc.anim, true)
	
	dealer.pickup = CreatePickup(336, loc.x,loc.y,loc.z - 110)
	SetPickupScale(dealer.pickup, 0.1,0.1,0.1)
	SetPickupPropertyValue(dealer.pickup, "color", "8A173A", true)

	SetPickupPropertyValue(dealer.pickup, "action", "Kuzkay:DrugsOpenDealer", true)
	SetPickupPropertyValue(dealer.pickup, "action_text", "Press [E] to interact", true)
	SetPickupPropertyValue(dealer.pickup, "action_range", 250, true)
end

AddRemoteEvent("Kuzkay:DrugsOpenDealer", function(player)
	local x,y,z = GetPlayerLocation(player)
	if GetDistance3D(x,y,z,dealer.loc.x,dealer.loc.y,dealer.loc.z) <= 400 then
		CallEvent("Kuzkay:ShopOpenShopMenu", player, "dealer")
	end
end)

function DealerChange()
	local rnd = math.random(1, #DealerLocations)
	local loc = DealerLocations[rnd]
	dealer.loc = loc

	SetNPCLocation(dealer.npc, loc.x, loc.y, loc.z)
	SetNPCAnimation(dealer.npc, loc.anim, true)
	DestroyPickup(dealer.pickup)

	dealer.pickup = CreatePickup(336, loc.x,loc.y,loc.z - 100)
	SetPickupScale(dealer.pickup, 1.5,1.5,0.5)
	SetPickupPropertyValue(dealer.pickup, "color", "8A173A", true)

	SetPickupPropertyValue(dealer.pickup, "action", "Kuzkay:DrugsOpenDealer", true)
	SetPickupPropertyValue(dealer.pickup, "action_text", "Press [E] to interact", true)
	SetPickupPropertyValue(dealer.pickup, "action_range", 250, true)

	SetNPCPropertyValue(dealer.npc, "dealer_text", loc.location)
end


function CreateLabs()
	for k,v in pairs(DrugStation) do
		v.object = CreatePickup(336, v.x, v.y, v.z - 120)

		SetPickupScale(v.object, 2.2,2.2,1.0)
		SetPickupPropertyValue(v.object, "action", "Kuzkay:DrugsOpenLab", true)
		SetPickupPropertyValue(v.object, "action_text", "Press [E] to open " .. v.drug .. " lab", true)
		SetPickupPropertyValue(v.object, "action_range", 400, true)
		SetPickupPropertyValue(v.object, "action_attr", k, true)
		SetPickupPropertyValue(v.object, "color", "ffffff")
	end
end

AddRemoteEvent("Kuzkay:DrugsOpenLab", function(player, labID)
	local x,y,z = GetPlayerLocation(player)
	local lab = DrugStation[labID]
	if GetDistance3D(x,y,z,lab.x,lab.y,lab.z) <= 600 then
		CallRemoteEvent(player, "Kuzkay:OpenDrugLab", lab.drug)
	end
end)

function CreatePlants()
	for k,v in pairs(plants) do
		local tem = templates[v.id]
		local rndS = (tem.scale)

		local rx = 0
		local ry = 0
		local rz = 0
		if tem.random then
			rx = math.random(-10,10)
			ry = math.random(0,360)
			rz = math.random(-10,10)
		end
		v.object = CreateObject(tem.model, v.x, v.y, (v.z - tem.zoffset), rx,ry,rz, rndS,rndS,rndS)
		v.grown = true
		SetObjectPropertyValue(v.object, "action", "Kuzkay:PlantsPickup", true)
		SetObjectPropertyValue(v.object, "action_text", "Press [E] to " .. tem.press_text, true)
		SetObjectPropertyValue(v.object, "action_range", 300, true)
		SetObjectPropertyValue(v.object, "action_attr", k, true)

		if tem.tint ~= nil then
			SetObjectPropertyValue(v.object, "tint", tem.tint, true)
			SetObjectPropertyValue(v.object, "tint_slot", tem.tint_slot, true)
			SetObjectPropertyValue(v.object, "tint_power", tem.tint_power, true)
		end

	end
end

local animPlayers = {}
function AnimationLoop(player, anim)
	SetPlayerAnimation(player, anim)
	Delay(4000, function()
		if animPlayers[player] and IsValidPlayer(player) then
			AnimationLoop(player, anim)
		end
	end)
end

function PickPlant(player, plant_id)
	local plant = plants[tonumber(plant_id)]
	local x,y,z = GetPlayerLocation(player)
	if GetDistance3D(x,y,z,plant.x,plant.y,plant.z) <= (400) and plant.grown then
		local tem = templates[plant.id]
		local duration = math.floor(tem.duration * 1000)
		CallRemoteEvent(player, "KNotify:AddProgressBar", tem.doing_text, tem.duration, "#86c967", "plant_picking")

		animPlayers[player] = true
		AnimationLoop(player, tem.anim)


		Delay(duration, function()
			animPlayers[player] = nil
			if plant.grown then
				local amount = math.random(tem.amount_min, tem.amount_max)
				if AddInventory(player, tem.item, amount) then
					plant.grown = false
					local rx,ry,rz = GetObjectRotation(plant.object)
					if tem.fall then
						SetObjectRotation(plant.object, -70,ry,rz)
					end

					

					SetObjectScale(plant.object, (tem.scale * 0.7),(tem.scale * 0.7),(tem.scale * 0.7))
					SetObjectPropertyValue(plant.object, "action_range", 0, true)
					if tem.remove_mat >= 0 then
						for l,p in pairs(GetAllPlayers()) do
							CallRemoteEvent(p, "Kuzkay:PlantsRemoveLeaves", plant.object, tem.remove_mat)
						end
					end
					if tem.remove then
						DestroyObject(plant.object)
					end
					Delay((tem.regrow * 1000) + Random(-tem.regrow * 0.2, tem.regrow * 0.2), function()
						plant.grown = true
						local rndS = (tem.scale)

						if tem.remove_mat >= 0 or tem.remove then
							if not tem.remove then
								DestroyObject(plant.object)
							end

							local rbx = 0
							local rby = 0
							local rbz = 0
							if tem.random then
								rbx = math.random(-10,10)
								rby = math.random(0,360)
								rbz = math.random(-10,10)
							end

							plant.object = CreateObject(tem.model, plant.x, plant.y, (plant.z - tem.zoffset), rbx,rby,rbz, rndS,rndS,rndS)
							SetObjectPropertyValue(plant.object, "action", "Kuzkay:PlantsPickup", true)
							SetObjectPropertyValue(plant.object, "action_text", "Press [E] to pick " .. tem.name, true)
							SetObjectPropertyValue(plant.object, "action_range", 300, true)
							SetObjectPropertyValue(plant.object, "action_attr", plant_id, true)

							if tem.tint ~= nil then
								SetObjectPropertyValue(plant.object, "tint", tem.tint, true)
								SetObjectPropertyValue(plant.object, "tint_slot", tem.tint_slot, true)
							end
						else

							local rbx = 0
							if tem.random then
								rbx = math.random(-10,10)
							end

							SetObjectPropertyValue(plant.object, "action_range", 300, true)
							SetObjectScale(plant.object, rndS,rndS,rndS)
							SetObjectRotation(plant.object, rbx,ry,rz)
						end
						
					end)
				end
			end
		end)
	end
end
AddRemoteEvent("Kuzkay:PlantsPickup", PickPlant)


local productionID = 0
local productions = {}
local soakingDuration = 4000
local dryingDuration = 6000
local crushingDuration = 8000
local collectDuration = 3000

AddRemoteEvent("Kuzkay:DrugsStartProduction", function(player, prodType)
	productionID = productionID + 1
	productions[player] = {}
	if prodType == "cocaine" then
		if RemoveInventory(player, "coca", 8) then
			productions[player].type = prodType
			productions[player].productionID = productionID
			CallRemoteEvent(player, "Kuzkay:DrugsStartProduction", prodType)
		else
			CallRemoteEvent(player, 'KNotify:Send', "You have no coca leaves to use", "#f00")
		end
	end

	if prodType == "heroin" then
		if RemoveInventory(player, "poppy", 6) then
			productions[player].type = prodType
			productions[player].productionID = productionID
			CallRemoteEvent(player, "Kuzkay:DrugsStartProduction", prodType)
		else
			CallRemoteEvent(player, 'KNotify:Send', "You have no poppy seeds to use", "#f00")
		end
	end
end)

AddRemoteEvent("Kuzkay:DrugsSoakItem", function(player, liquid)
	if productions[player] ~= nil then
		if productions[player].type == "cocaine" then

			CallRemoteEvent(player, "Kuzkay:DrugsFreezeDraggable")
			CallRemoteEvent(player, "KNotify:AddProgressBar", "Soaking leaves", (soakingDuration / 1000), "#a39a93", "soaking_coke")
			Delay(soakingDuration, function()
				if productions[player].liquid ~= nil and productions[player].liquid ~= liquid and (productions[player].dry == nil or productions[player].dry == false) then
					productions[player].liquid = "mix"
					productions[player].dry = nil
					productions[player].broken = true
				else
					productions[player].dry = nil
					if productions[player].liquid == "acetone" then
						CallRemoteEvent(player, "Kuzkay:DrugsFry")
						productions[player].dry = true
					end
					productions[player].liquid = liquid
				end

				if liquid == "gasoline" and productions[player].hasgasoline then
					productions[player].gasoline = true
				end

				if liquid == "acetone" and productions[player].hasacetone then
					productions[player].acetone = true
				end

				CallRemoteEvent(player, "Kuzkay:DrugsSetSoakedItem", productions[player].liquid)
			end)

		end


		if productions[player].type == "heroin" then

			CallRemoteEvent(player, "Kuzkay:DrugsFreezeDraggable")
			CallRemoteEvent(player, "KNotify:AddProgressBar", "Mixing", (soakingDuration / 1000), "#a39a93", "soaking_coke")
			Delay(soakingDuration, function()

				if productions[player].liquid ~= nil and productions[player].liquid ~= liquid and (productions[player].crushed == nil or productions[player].crushed == false) or (not productions[player].crushed and liquid == "acetone")then
					productions[player].liquid = "mix"
					productions[player].dry = nil
					productions[player].broken = true
					CallRemoteEvent(player, "Kuzkay:DrugsFry")
				else
					if productions[player].acetone or liquid == "acetone" then
						productions[player].liquid = liquid
					else
						productions[player].liquid = "mix"
						productions[player].broken = true
						CallRemoteEvent(player, "Kuzkay:DrugsFry")
					end
				end

				if liquid == "calcium" and productions[player].hascalcium then
					productions[player].calcium = true

				end

				if liquid == "acetone" and productions[player].hasacetone then
					productions[player].acetone = true
				end

				CallRemoteEvent(player, "Kuzkay:DrugsSetSoakedItem", productions[player].liquid)
			end)

		end
	end
end)

AddRemoteEvent("Kuzkay:DrugsDry", function(player)
	if productions[player] ~= nil then
		if productions[player].type == "cocaine" then
			CallRemoteEvent(player, "Kuzkay:DrugsFreezeDraggable")
			CallRemoteEvent(player, "KNotify:AddProgressBar", "Drying leaves", (dryingDuration / 1000), "#a39a93", "drying_coke")
			Delay(dryingDuration, function()
				if productions[player].dry == nil then
			 		productions[player].dry = true
					CallRemoteEvent(player, "Kuzkay:DrugsDried")
				else
					CallRemoteEvent(player, "Kuzkay:DrugsFry")
					productions[player].broken = true
				end
			end)
			
		end
	end
end)

AddRemoteEvent("Kuzkay:DrugsAddAddon", function(player, addType)
	if productions[player] ~= nil then
		if productions[player].type == "cocaine" then
			if addType == "gasoline" then
				if productions[player].hasgasoline == nil then
					if RemoveInventory(player, "jerican", 1) then
						productions[player].hasgasoline = true
						CallRemoteEvent(player, "Kuzkay:DrugsAppendAddon", addType)
					end
				end
			end

			if addType == "acetone" then
				if productions[player].hasacetone == nil then
					if RemoveInventory(player, "acetone", 1) then
						productions[player].hasacetone = true
						CallRemoteEvent(player, "Kuzkay:DrugsAppendAddon", addType)
					end
				end
			end
		end

		if productions[player].type == "heroin" then
			if addType == "calcium" then
				if productions[player].hascalcium == nil then
					if RemoveInventory(player, "calcium", 1) then
						productions[player].hascalcium = true
						CallRemoteEvent(player, "Kuzkay:DrugsAppendAddon", addType)
					end
				end
			end

			if addType == "acetone" then
				if productions[player].hasacetone == nil then
					if RemoveInventory(player, "acetone", 1) then
						productions[player].hasacetone = true
						CallRemoteEvent(player, "Kuzkay:DrugsAppendAddon", addType)
					end
				end
			end
		end
	end
end)

AddRemoteEvent("Kuzkay:DrugsCrush", function(player)
	if productions[player] ~= nil then
		if productions[player].type == "cocaine" then
			CallRemoteEvent(player, "Kuzkay:DrugsFreezeDraggable")
			CallRemoteEvent(player, "KNotify:AddProgressBar", "Crushing leaves", (crushingDuration / 1000), "#a39a93", "crushing_coke")
			Delay(crushingDuration, function()
				if productions[player].acetone == true and productions[player].gasoline == true and productions[player].dry == true then
					CallRemoteEvent(player, "Kuzkay:DrugsCrush", "crushed")
					productions[player].crushed = true
				else
					CallRemoteEvent(player, "Kuzkay:DrugsCrush", "crushed-broken")
					productions[player].broken = true
				end
			end)
			
		end


		if productions[player].type == "heroin" then
			CallRemoteEvent(player, "Kuzkay:DrugsFreezeDraggable")
			CallRemoteEvent(player, "KNotify:AddProgressBar", "Crushing", (crushingDuration / 1000), "#a39a93", "crushing_poppies")
			Delay(crushingDuration, function()
				CallRemoteEvent(player, "Kuzkay:DrugsCrush", "crushed")
				productions[player].crushed = true
				if productions[player].acetone and productions[player].calcium and productions[player].broken ~= true then
					productions[player].dry = true
					CallRemoteEvent(player, "Kuzkay:DrugsCrush", "finished")
				end
			end)
			
		end
	end
end)

AddRemoteEvent("Kuzkay:DrugsCollect", function(player)
	if productions[player] ~= nil then
		if productions[player].type == "cocaine" then
			CallRemoteEvent(player, "Kuzkay:DrugsFreezeDraggable")
			CallRemoteEvent(player, "KNotify:AddProgressBar", "Collecting cocaine", (collectDuration / 1000), "#a39a93", "collect_coke")
			Delay(collectDuration, function()
				if productions[player].acetone == true and productions[player].gasoline == true and productions[player].dry == true and productions[player].crushed and not productions[player].broken then
					if AddInventory(player, "cocaine", math.random(1,3)) then
						CallRemoteEvent(player, "Kuzkay:DrugsFinish")
						productions[player] = nil
					end
				end
			end)
			
		end

		if productions[player].type == "heroin" then
			CallRemoteEvent(player, "Kuzkay:DrugsFreezeDraggable")
			CallRemoteEvent(player, "KNotify:AddProgressBar", "Collecting heroin", (collectDuration / 1000), "#a39a93", "collect_heroin")
			Delay(collectDuration, function()
				if productions[player].acetone == true and productions[player].calcium == true and productions[player].crushed and not productions[player].broken then
					if AddInventory(player, "heroin", math.random(3,4)) then
						CallRemoteEvent(player, "Kuzkay:DrugsFinish")
						productions[player] = nil
					end
				end
			end)
			
		end
	end
end)

AddRemoteEvent("Kuzkay:DrugsRestartProduction", function(player)
	if productions[player] ~= nil then
		CallRemoteEvent(player, "Kuzkay:DrugsRestarted", productions[player].type) 
		productions[player] = nil
	end
end)

AddEvent("OnPlayerQuit", function(player)
	productions[player] = nil
end)