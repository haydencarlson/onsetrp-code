AddEvent("OnKeyPress", function(key)
    if key == "E" then

        local x, y, z = GetPlayerLocation()

        -- Object interaction
        local objects = GetStreamedObjects()
        for key, object in pairs(objects) do
            local action = GetObjectPropertyValue(object, "action")
            if action ~= nil then
                local px,py,pz = GetObjectLocation(object)
                if GetDistance3D(x, y, z, px, py, pz) <= 250 then
                    CallRemoteEvent("RPNotify:ObjectInteract_" .. action, object)
                end
            end
        end
        -- NPC Interaction
        for key,npc in pairs(GetStreamedNPC()) do
            local action = GetNPCPropertyValue(npc, "action")
            if action ~= nil then
                local px,py,pz = GetNPCLocation(npc)
                if GetDistance3D(x, y, z, px, py, pz) <= 250 then
                    CallRemoteEvent("RPNotify:ObjectInteract_" .. action, object)
                end
            end
        end
    end
end)

