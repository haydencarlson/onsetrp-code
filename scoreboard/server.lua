function Scoreboard_RequestUpdate(player)
  local _send = {}
  for _, v in ipairs(GetAllPlayers()) do
    _send[v] = {
      ['name'] = GetPlayerName(v),
      ['ping'] = GetPlayerPing(v),
      ['id'] = v,
      ['job'] = PlayerData[player].job,
      ['admin'] = PlayerData[player].admin == 1
    }
  end
  local admin = PlayerData[player].admin == 1
  CallRemoteEvent(player, 'OnServerScoreboardUpdate', _send, GetServerName(), #GetAllPlayers(), GetMaxPlayers(), admin)
end
AddRemoteEvent('RequestScoreboardUpdate', Scoreboard_RequestUpdate)