local NotificationHud

AddEvent("OnPackageStart", function()
    NotificationHud = CreateWebUI(0, 0, 0, 0, 0, 32)
    SetWebAlignment(NotificationHud, 0.0, 0.0)
    SetWebAnchors(NotificationHud, 0.0, 0.0, 1.0, 1.0)
    LoadWebFile(NotificationHud, "http://asset/onsetrp/notification/notification/notification.html")
    SetWebVisibility(NotificationHud, WEB_HITINVISIBLE)
end)

function MakeNotification(text, color)
    CreateSound("noti.mp3")
    ExecuteWebJS(NotificationHud, 'makeNotification("' ..text.. '", "' ..color.. '")')
end
AddRemoteEvent("MakeNotification", MakeNotification)

