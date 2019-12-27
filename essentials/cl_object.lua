AddEvent("OnKeyPress", function(key)
    if key == "E" then
        -- Object interaction
        local objects = GetStreamedObjects()
        local x, y, z = GetPlayerLocation()
        for key, object in pairs(objects) do
            local action = GetObjectPropertyValue(object, "action")
            if action ~= nil then
                local px,py,pz = GetObjectLocation(object)
                if GetDistance3D(x, y, z, px, py, pz) <= 250 then
                    CallRemoteEvent("RPNotify:ObjectInteract_" .. action)
                end
            end
        end
    end
end)

