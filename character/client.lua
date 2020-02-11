local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Camera = ImportPackage('camera')
local characterCreation
UIOpen = false
local isCreated = true

local playerName = ""
local playerHairs = ""
local playerHairsColor = ""
local playerShirt = ""
local playerPants = ""
local playerShoes = ""

onCharacterCreation = false

AddRemoteEvent("SetUIOpenStatusClient", function(isOpen)
    UIOpen = isOpen
end) 


AddRemoteEvent("SetPlayerClothingToPreset", function(playerToChange, preset)
    SetPlayerClothingPreset(playerToChange, preset)
end)

AddEvent("OnKeyPress", function(key)
    if onCharacterCreation then
        if playerName == "" then
            return
        end
        if playerHairs == "" then
            return Dialog.show(hairsCreation)
        end
        if playerHairs == "" or  playerHairsColor == "" then
            return Dialog.show(hairsCreation)
        end
        if playerShirt == "" then
            return Dialog.show(hairsCreation)
        end
        if playerPants == "" then
            return Dialog.show(pantsCreation)
        end
        if playerShoes == "" then
            return Dialog.show(shoesCreation)
        end
    end
end)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
    CallRemoteEvent("UpdateClothingStreamIn", otherplayer)
end)

AddRemoteEvent("characterize:ClientSubmit", function(isCreating)
    if isCreating then
        isCreated = true
        StartTutorial()
        CallRemoteEvent("JobGuyInteract")
        CallRemoteEvent("account:setplayernotbusy", GetPlayerId())
    end
end)

AddRemoteEvent( "askClientCreation", function() 
    isCreated = false
    onCharacterCreation = true
    CallRemoteEvent("SendIsCreatedToInfoUI", isCreated)
end)

function StartTutorial()
    SetIgnoreMoveInput(true)
    SetInputMode(INPUT_UI)
end

AddRemoteEvent("ClientChangeClothing", function(player, part, piece, r, g, b, a)
    local SkeletalMeshComponent
    local pieceName
    if part == 0 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing0")
        pieceName = piece
    elseif part == 1 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
        pieceName = piece
    elseif part == 4 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
        pieceName = piece
    elseif part == 5 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing5")
        pieceName = piece
    elseif part == 6 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
        SkeletalMeshComponent:SetMaterial(3, UMaterialInterface.LoadFromAsset(BodyMaterial[piece]))
    end
    if pieceName ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
    end
    if part == 0 then
        local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
        DynamicMaterialInstance:SetColorParameter("Hair Color", FLinearColor(r or 0, g or 0, b or 0, a or 0))
    end
    if part == 1 then
        SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(GetPlayerId(), "Clothing2")
        SkeletalMeshComponent:SetSkeletalMesh(nil)
		local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
		SkeletalMeshComponent:SetColorParameterOnMaterials("Clothing Color", FLinearColor(r, g, b, a))
    end
    if part == 4 then
        local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
		SkeletalMeshComponent:SetColorParameterOnMaterials("Clothing Color", FLinearColor(r, g, b, a))
    end
end)

BodyMaterial = {
    noClothes = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoClothes",
    noLegs = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoLegs",
    noShoes = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoes",
    noShoesLegs = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegs",
    noShoesLegsTorso = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso",
    noTorso = "/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoTorso"
}
