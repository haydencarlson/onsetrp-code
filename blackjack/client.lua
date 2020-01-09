local function OnPackageStart() 
    blackjackui = CreateWebUI(0.0, 0.0, 0.0, 0.0, 5, 16)
    LoadWebFile(blackjackui, "http://asset/onsetrp/blackjack/ui/index.html")
    local x, y = GetScreenSize()
    SetWebSize(blackjackui, x, y)
    SetWebAlignment(blackjackui, 0.5, 0.5)
    SetWebAnchors(blackjackui, 0.5, 0.5, 0.5, 0.5)
    SetWebVisibility(blackjackui, WEB_HIDDEN)
end

AddEvent("OnPackageStart", OnPackageStart)

AddEvent("Blackjack:Close", function()
    SetWebVisibility(blackjackui, WEB_HIDDEN)
    SetInputMode(INPUT_GAME)
end)

AddEvent("StartNewBlackjackGame", function(bet_amount)
    CallRemoteEvent("NewPlayerGameStart", bet_amount)
end)

AddRemoteEvent("ShowBlackJack", function()
    SetInputMode(INPUT_UI)
    ShowMouseCursor(true)
    SetWebVisibility(blackjackui, WEB_VISIBLE)
end)
