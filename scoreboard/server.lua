function Scoreboard_RequestUpdate(player)
  local _send = {}
  for _, v in ipairs(GetAllPlayers()) do
    _send[v] = {
      ['name'] = GetPlayerName(v),
      ['ping'] = GetPlayerPing(v),
      ['id'] = v,
      ['job'] = PlayerData[v].job,
      ['sessiontime'] = PlayerData[v].time,
      ['admin'] = PlayerData[v].admin == 1
    }
  end
  local admin = PlayerData[player].admin == 1
  local session = PlayerData[player].time
  CallRemoteEvent(player, 'OnServerScoreboardUpdate', _send, GetServerName(), #GetAllPlayers(), GetMaxPlayers(), admin, session)
end
AddRemoteEvent('RequestScoreboardUpdate', Scoreboard_RequestUpdate)