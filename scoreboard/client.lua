-- Based on digital scoreboard on onset sandbox editor gamemode 

local ScoreboardUI = 0
local ScoreboardFirstOpen = false

function Scoreboard_OnPackageStart()
  ScoreboardUI = CreateWebUI(0.0, 0.0, 0.0, 0.0, 1, 60)
  SetWebAnchors(ScoreboardUI, 0.0, 0.0, 1.0, 1.0)
  LoadWebFile(ScoreboardUI, 'http://asset/' .. GetPackageName() .. '/scoreboard/scoreboard/scoreboard.html')
  SetWebVisibility(ScoreboardUI, WEB_HIDDEN)
end
AddEvent("OnPackageStart", Scoreboard_OnPackageStart)

function Scoreboard_OnKeyPress(key)
  if key == 'Tab' then
    ShowMouseCursor(true)
    CallRemoteEvent('RequestScoreboardUpdate')
    CallRemoteEvent('RequestScoreboardLaws')
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(ScoreboardUI, WEB_VISIBLE)
  end
end
AddEvent('OnKeyPress', Scoreboard_OnKeyPress)

function Scoreboard_OnKeyRelease(key)
  if key == 'Tab' then
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    SetWebVisibility(ScoreboardUI, WEB_HIDDEN)
  end
end
AddEvent('OnKeyRelease', Scoreboard_OnKeyRelease)

function Scoreboard_OnServerScoreboardUpdate(data, name, players, maxplayers, rank)
  if data == nil then return end

  ExecuteWebJS(ScoreboardUI, 'ResetScoreboard()')
  ExecuteWebJS(ScoreboardUI, 'SetInformation("' .. name .. '", ' .. players .. ', ' .. maxplayers .. ')')
  for _, v in pairs(data) do
    if v['job'] == "" then
      v['job'] = "Citizen"
    end
    if rank ~= nil then
      ExecuteWebJS(ScoreboardUI, 'AddPlayer("' .. v['name'] ..  ' (' .. v['id'] .. ')' .. '", "' .. v['job'] .. '", "' .. v['sessiontime'] .. '", "'.. tostring(v['rank']) .. '", ' .. v['ping'] .. ')')
    else
      ExecuteWebJS(ScoreboardUI, 'AddPlayer("' .. v['name'] .. '", "' .. v['job'] .. '", "' .. v['sessiontime'] .. '", "'.. tostring(v['rank']) .. '", ' .. v['ping'] .. ')')
    end
  end
end
AddRemoteEvent('OnServerScoreboardUpdate', Scoreboard_OnServerScoreboardUpdate)

function Scoreboard_OnServerLawUpdate(laws)
  ExecuteWebJS(ScoreboardUI, 'AddLaws(' .. laws .. ')')
end
AddRemoteEvent('OnServerLawUpdate', Scoreboard_OnServerLawUpdate)