ws = ImportPackage("webuistreamer")
local web = ws.CreateRemoteWebUI3D( 173430.34375, 198950.296875, 2900.1923828125, 0.0, -360.0, 0.0, 1280, 720, 60, 2200)

AddEvent("OnPackageStart", function()
    cinemaenterobject = CreateObject(340, 173869, 197698, 1310)
    SetObjectPropertyValue(cinemaenterobject, "action", "cinemaenter", true)
    CreateText3D("Enter Cinema \n Press E", 18, 173869, 197698, 1310 + 120, 0, 0, 0)

    cinemaleaveobject = CreateObject(340, 174436, 198113, 2392)
    SetObjectPropertyValue(cinemaleaveobject, "action", "cinemaleave", true)
    CreateText3D("Exit Cinema \n Press E", 18, 174436, 198113, 2392 + 120, 0, 0, 0)
end)

AddEvent("startembed", function(link)
    ws.SetWebUI3DUrl(web, "https://youtube.com/embed/"..link.."?autoplay=1")
 end)

 AddEvent("startfs", function(link)
    ws.SetWebUI3DUrl(web, "https://youtube.com/watch?v="..link.."?autoplay=1")
 end)
 
AddCommand("play", function(player, link)
    for k, v in pairs(GetPlayersInRange3D(173430.34375, 198950.296875, 2900.1923828125, 2200)) do
        if PlayerData[v].job == 'Cinema Manager' then
            if link ~= nil then 
                CallEvent("startembed", link)
            else
                AddPlayerChat(player, "Usage: /play [VideoID]")
            end
        end
    end
    if PlayerData[player].job ~= 'Cinema Manager' then
        AddPlayerChat(player, "You must be a cinema manager to do this.")
    end 
end)

AddCommand("play_fullscreen", function(player, link) 
    for k, v in pairs(GetPlayersInRange3D(173430.34375, 198950.296875, 2900.1923828125, 2200)) do
        if PlayerData[v].job == 'Cinema Manager' then
            if link ~= nil then
                CallEvent("startfs", link)
            else
                AddPlayerChat(player, "Usage: /play [VideoID]")
            end
        end
    end
    if PlayerData[player].job ~= 'Cinema Manager' then
        AddPlayerChat(player, "You must be a cinema manager to do this.")
    end
end)

AddRemoteEvent("StartCinemaJob", function(player) 
    PlayerData[player].job = 'Cinema Manager'
    CallRemoteEvent(player, "RPNotify:HUDEvent", "job", "Cinema Manager")
end)
AddRemoteEvent("StopCinemaJob", function(player)
    PlayerData[player].job = ''
end)
AddRemoteEvent("RPNotify:ObjectInteract_cinemaenter", function(player, object)
    SetPlayerLocation(player, 173709, 198107, 2492)
end)

AddRemoteEvent("RPNotify:ObjectInteract_cinemaleave", function(player, object)
    SetPlayerLocation(player, 173870, 197423, 1310)
end)