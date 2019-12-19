AddEvent("OnKeyPress", function(key)
    if key == "X" then
        CallRemoteEvent("HandsUp") 
    end
end)

AddEvent("OnKeyRelease", function(key)
    if key == "X" then
        CallRemoteEvent("HandsUps") 
    end
end)
