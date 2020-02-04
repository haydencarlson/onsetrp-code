function GetPlayerTimes(player)
	PlayerData[player].times = math.floor(PlayerData[player].times + (GetTimeSeconds() - PlayerData[player].play_times))
	PlayerData[player].play_times = GetTimeSeconds()
	return PlayerData[player].times
end

function Scoreboard_RequestUpdate(player)
  
  local _send = {}
  for _, v in ipairs(GetAllPlayers()) do
    if PlayerData[v] ~= nil then
      _send[v] = {
        ['name'] = GetPlayerName(v),
        ['ping'] = GetPlayerPing(v),
        ['id'] = v,
        ['job'] = PlayerData[v].job,
        ['sessiontime'] = GetPlayerTimes(v),
        ['rank'] = GetPlayerRank(v)
      }
    end
  end
  local rank = GetPlayerRank(player)
  local session = GetPlayerTimes(player)
  CallRemoteEvent(player, 'OnServerScoreboardUpdate', _send, GetServerName(), #GetAllPlayers(), GetMaxPlayers(), rank, session)
end
AddRemoteEvent('RequestScoreboardUpdate', Scoreboard_RequestUpdate)