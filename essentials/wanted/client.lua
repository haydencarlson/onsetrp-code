local WantedHud

function OnPackageStart()

WantedHud = CreateTextBox(-15, 320, "", "right" )
SetTextBoxAnchors(WantedHud, 1.0, 0.0, 1.0, 0.0)
SetTextBoxAlignment(WantedHud, 1.0, 0.0)
end
AddEvent("OnPackageStart", OnPackageStart)

CreateTimer(function()
    local player = GetPlayerId()
    local wanted = GetPlayerPropertyValue(player, "isWanted")
    if wanted == 1 then
        SetTextBoxText(WantedHud, '<span color="#800000">Wanted!</>')
    elseif wanted == 0 or nil then
         SetTextBoxText(WantedHud, "")
    end
end, 250)