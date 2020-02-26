local targetWaypoint = {
    playerId = false,
    waypointId = false
}

AddRemoteEvent("Hitman:AddTargetWaypoint", function(targetId, targetName, x, y, z)
    if targetWaypoint['waypointId'] ~= false then
        DestroyWaypoint(targetWaypoint['waypointId'])
    end
    targetWaypoint['waypointId'] = CreateWaypoint(x, y, z, targetName)
    targetWaypoint['playerId'] = targetId
end)

AddRemoteEvent("Hitman:UpdateWaypoint", function(xt, yt, zt)
    local x, y, z = GetPlayerLocation()
    local x2, y2, z2 = GetWaypointLocation(targetWaypoint['waypointId'])
    local distance = GetDistance3D(x, y, z, x2, y2, z2)
    if distance <= 3000 then
        DestroyWaypoint(targetWaypoint['waypointId'])
    else
        SetWaypointLocation(targetWaypoint['waypointId'], xt, yt, zt)
    end
end)

CreateTimer(function()
    if targetWaypoint['waypointId'] then
        CallRemoteEvent("Hitman:RequestWaypointUpdate", targetWaypoint['playerId'])
    end
end, 250)
