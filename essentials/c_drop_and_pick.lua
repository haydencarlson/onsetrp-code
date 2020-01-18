
AddEvent("OnKeyPress", function(key)
    if key == 'B' and not UIOpen and not onCharacterCreation then
        CallRemoteEvent("DropGun")
    end
    if key == 'B' and not UIOpen and not onCharacterCreation then
        CallRemoteEvent("PickupGun", GetStreamedObjects(false))
    end
end)
