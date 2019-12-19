AddCommand("workout", function(playerid)
local x, y, z = GetPlayerLocation(playerid)
 	SetPlayerAnimation(playerid, "PUSHUP_START")	
           Delay(1500, function(player) SetPlayerAnimation(playerid, "PUSHUP_IDLE")
	end)
    	   Delay(5000, function(player) SetPlayerAnimation(playerid, "PUSHUP_END")
	end)
   	   Delay(6000, function(player) AddPlayerChatRange(x, y, 50.0, "[Workout] "..GetPlayerName(playerid)..": Life has its ups and downs, I call it push ups. ")
	end)
	 Delay(6000, function(player) if GetPlayerArmor(playerid) < 5.0 then
		SetPlayerArmor(playerid, 15.0)
	else
			return
		end
	end)
	Delay(6000, function(player) removePlayerThirst(playerid, 25)
     end)
end)

AddCommand("stop", function(playerid)
    SetPlayerAnimation(playerid, "STOP")
end)

AddRemoteEvent("HandsUp", function(playerid)
SetPlayerAnimation(playerid, "HANDSUP_STAND")
  end)

AddRemoteEvent("HandsUps", function(playerid)
SetPlayerAnimation(playerid, "STOP")
  end)

AddCommand("puke", function(playerid)
    SetPlayerAnimation(playerid, "VOMIT")
end)

AddCommand("salute", function(playerid)
    SetPlayerAnimation(playerid, "SALUTE")
end)

AddCommand("thumbsup", function(playerid)
    SetPlayerAnimation(playerid, "THUMBSUP")
end)

AddCommand("crazy", function(playerid)
    SetPlayerAnimation(playerid, "CRAZYMAN")
end)

AddCommand("yikes", function(playerid)
    SetPlayerAnimation(playerid, "DARKSOULS")
end)

AddCommand("smoking", function(playerid)
    SetPlayerAnimation(playerid, "SMOKING")
end)

AddCommand("clap", function(playerid)
    SetPlayerAnimation(playerid, "CLAP")
end)

AddCommand("bow", function(playerid)
    SetPlayerAnimation(playerid, "BOW")
end)

AddCommand("stretch", function(playerid)
    SetPlayerAnimation(playerid, "STRETCH")
end)

AddCommand("wave", function(playerid)
    SetPlayerAnimation(playerid, "WAVE")
end)

AddCommand("wave2", function(playerid)
    SetPlayerAnimation(playerid, "WAVE2")
end) 

AddCommand("dab", function(playerid)
    SetPlayerAnimation(playerid, "DABSAREGAY")
end)

AddCommand("crossarms", function(playerid)
    SetPlayerAnimation(playerid, "CROSSARMS")
end)

AddCommand("dontknow", function(playerid)
    SetPlayerAnimation(playerid, "DONTKNOW")
end)

AddCommand("dustoff", function(playerid)
    SetPlayerAnimation(playerid, "DUSTOFF")
end)

AddCommand("facepalm", function(playerid)
    SetPlayerAnimation(playerid, "FACEPALM")
end)

AddCommand("flex", function(playerid)
    SetPlayerAnimation(playerid, "FLEXX")
end)

AddCommand("dontlisten", function(playerid)
    SetPlayerAnimation(playerid, "IDONTLISTEN")
end)

AddCommand("justright", function(playerid)
    SetPlayerAnimation(playerid, "ITSJUSTRIGHT")
end)

AddCommand("fallonknees", function(playerid)
    SetPlayerAnimation(playerid, "FALLONKNEES")
end)

AddCommand("kungfu", function(playerid)
    SetPlayerAnimation(playerid, "KUNGFU")
end)

AddCommand("callme", function(playerid)
    SetPlayerAnimation(playerid, "CALLME")
end)

AddCommand("shoosh", function(playerid)
    SetPlayerAnimation(playerid, "SHOOSH")
end)

AddCommand("slapass", function(playerid)
    SetPlayerAnimation(playerid, "SLAPOWNASS")
end)

AddCommand("slapass2", function(playerid)
    SetPlayerAnimation(playerid, "SLAPOWNASS2")
end)

AddCommand("throatslit", function(playerid)
    SetPlayerAnimation(playerid, "THROATSLIT")
end)

AddCommand("wave3", function(playerid)
    SetPlayerAnimation(playerid, "WAVE3")
end)

AddCommand("sweating", function(playerid)
    SetPlayerAnimation(playerid, "WIPEOFFSWEAT")
end)

AddCommand("guards", function(playerid)
    SetPlayerAnimation(playerid, "CALL_GUARDS")
end)

AddCommand("call", function(playerid)
    SetPlayerAnimation(playerid, "CALL_SOMEONE")
end)

AddCommand("call2", function(playerid)
    SetPlayerAnimation(playerid, "CALL_SOMEONE2")
end)

AddCommand("checkeq", function(playerid)
    SetPlayerAnimation(playerid, "CHECK_EQUIPMENT")
end)

AddCommand("checkeq2", function(playerid)
    SetPlayerAnimation(playerid, "CHECK_EQUIPMENT2")
end)

AddCommand("checkeq3", function(playerid)
    SetPlayerAnimation(playerid, "CHECK_EQUIPMENT3")
end)

AddCommand("clap2", function(playerid)
    SetPlayerAnimation(playerid, "CLAP2")
end)

AddCommand("clap3", function(playerid)
    SetPlayerAnimation(playerid, "CLAP3")
end)

AddCommand("cheer", function(playerid)
    SetPlayerAnimation(playerid, "CHEER")
end)

AddCommand("drunk", function(playerid)
    SetPlayerAnimation(playerid, "DRUNK")
end)

AddCommand("fixstuff", function(playerid)
    SetPlayerAnimation(playerid, "FIX_STUFF")
end)

AddCommand("gethere", function(playerid)
    SetPlayerAnimation(playerid, "GET_HERE")
end)

AddCommand("gethere2", function(playerid)
    SetPlayerAnimation(playerid, "GET_HERE2")
end)

AddCommand("goaway", function(playerid)
    SetPlayerAnimation(playerid, "GOAWAY")
end)

AddCommand("laugh", function(playerid)
    SetPlayerAnimation(playerid, "LAUGH")
end)

AddCommand("thinking", function(playerid)
    SetPlayerAnimation(playerid, "THINKING")
end)

AddCommand("throw", function(playerid)
    SetPlayerAnimation(playerid, "THROW")
end)

AddCommand("salute2", function(playerid)
    SetPlayerAnimation(playerid, "SALUTE2")
end)

AddCommand("triumph", function(playerid)
    SetPlayerAnimation(playerid, "TRIUMPH")
end)

AddCommand("windows", function(playerid)
    SetPlayerAnimation(playerid, "WASH_WINDOWS")
end)

AddCommand("watching", function(playerid)
    SetPlayerAnimation(playerid, "WATCHING")
end)

AddCommand("revive", function(playerid)
    SetPlayerAnimation(playerid, "REVIVE")
end)

AddCommand("crossarms2", function(playerid)
    SetPlayerAnimation(playerid, "CROSSARMS2")
end)

AddCommand("shrug", function(playerid)
    SetPlayerAnimation(playerid, "SHRUG")
end)

AddCommand("yawn", function(playerid)
    SetPlayerAnimation(playerid, "YAWN")
end)

AddCommand("handshake", function(playerid)
    SetPlayerAnimation(playerid, "HANDSHAKE")
end)

AddCommand("fishing", function(playerid)
    SetPlayerAnimation(playerid, "FISHING")
end)

AddCommand("smoking2", function(playerid)
    SetPlayerAnimation(playerid, "SMOKING01")
end)

AddCommand("smoking3", function(playerid)
    SetPlayerAnimation(playerid, "SMOKING02")
end)

AddCommand("smoking4", function(playerid)
    SetPlayerAnimation(playerid, "SMOKING03")
end)

AddCommand("lean", function(playerid)
    SetPlayerAnimation(playerid, "WALLLEAN01")
end)

AddCommand("lean2", function(playerid)
    SetPlayerAnimation(playerid, "WALLLEAN02")
end)

AddCommand("lean3", function(playerid)
    SetPlayerAnimation(playerid, "WALLLEAN03")
end)

AddCommand("lean4", function(playerid)
    SetPlayerAnimation(playerid, "WALLLEAN04")
end)

AddCommand("dance", function(playerid)
    SetPlayerAnimation(playerid, "DANCE01")
end)

AddCommand("dance2", function(playerid)
    SetPlayerAnimation(playerid, "DANCE02")
end)

AddCommand("dance3", function(playerid)
    SetPlayerAnimation(playerid, "DANCE03")
end)

AddCommand("dance4", function(playerid)
    SetPlayerAnimation(playerid, "DANCE04")
end)

AddCommand("dance5", function(playerid)
    SetPlayerAnimation(playerid, "DANCE05")
end)

AddCommand("dance6", function(playerid)
    SetPlayerAnimation(playerid, "DANCE06")
end)

AddCommand("dance7", function(playerid)
    SetPlayerAnimation(playerid, "DANCE07")
end)

AddCommand("dance8", function(playerid)
    SetPlayerAnimation(playerid, "DANCE08")
end)

AddCommand("dance9", function(playerid)
    SetPlayerAnimation(playerid, "DANCE09")
end)

AddCommand("dance10", function(playerid)
    SetPlayerAnimation(playerid, "DANCE10")
end)

AddCommand("dance11", function(playerid)
    SetPlayerAnimation(playerid, "DANCE11")
end)

AddCommand("dance12", function(playerid)
    SetPlayerAnimation(playerid, "DANCE12")
end)

AddCommand("dance13", function(playerid)
    SetPlayerAnimation(playerid, "DANCE13")
end)

AddCommand("dance14", function(playerid)
    SetPlayerAnimation(playerid, "DANCE14")
end)

AddCommand("dance15", function(playerid)
    SetPlayerAnimation(playerid, "DANCE15")
end)

AddCommand("dance16", function(playerid)
    SetPlayerAnimation(playerid, "DANCE16")
end)

AddCommand("dance17", function(playerid)
    SetPlayerAnimation(playerid, "DANCE17")
end)

AddCommand("dance18", function(playerid)
    SetPlayerAnimation(playerid, "DANCE18")
end)

AddCommand("dance19", function(playerid)
    SetPlayerAnimation(playerid, "DANCE19")
end)

AddCommand("dance20", function(playerid)
    SetPlayerAnimation(playerid, "DANCE20")
end)

AddCommand("lay", function(playerid)
    SetPlayerAnimation(playerid, "LAY01")
end)

AddCommand("lay2", function(playerid)
    SetPlayerAnimation(playerid, "LAY02")
end)

AddCommand("lay3", function(playerid)
    SetPlayerAnimation(playerid, "LAY03")
end)

AddCommand("lay4", function(playerid)
    SetPlayerAnimation(playerid, "LAY04")
end)

AddCommand("lay5", function(playerid)
    SetPlayerAnimation(playerid, "LAY05")
end)

AddCommand("lay6", function(playerid)
    SetPlayerAnimation(playerid, "LAY06")
end)

AddCommand("lay7", function(playerid)
    SetPlayerAnimation(playerid, "LAY07")
end)

AddCommand("lay8", function(playerid)
    SetPlayerAnimation(playerid, "LAY08")
end)

AddCommand("lay9", function(playerid)
    SetPlayerAnimation(playerid, "LAY09")
end)

AddCommand("lay10", function(playerid)
    SetPlayerAnimation(playerid, "LAY10")
end)

AddCommand("lay11", function(playerid)
    SetPlayerAnimation(playerid, "LAY11")
end)

AddCommand("lay12", function(playerid)
    SetPlayerAnimation(playerid, "LAY12")
end)

AddCommand("lay13", function(playerid)
    SetPlayerAnimation(playerid, "LAY13")
end)

AddCommand("lay14", function(playerid)
    SetPlayerAnimation(playerid, "LAY14")
end)

AddCommand("lay15", function(playerid)
    SetPlayerAnimation(playerid, "LAY15")
end)

AddCommand("lay16", function(playerid)
    SetPlayerAnimation(playerid, "LAY16")
end)

AddCommand("lay17", function(playerid)
    SetPlayerAnimation(playerid, "LAY17")
end)

AddCommand("lay18", function(playerid)
    SetPlayerAnimation(playerid, "LAY18")
end)

AddCommand("sit", function(playerid)
    SetPlayerAnimation(playerid, "SIT01")
end)

AddCommand("sit2", function(playerid)
    SetPlayerAnimation(playerid, "SIT02")
end)

AddCommand("sit3", function(playerid)
    SetPlayerAnimation(playerid, "SIT03")
end)

AddCommand("sit4", function(playerid)
    SetPlayerAnimation(playerid, "SIT04")
end)

AddCommand("sit5", function(playerid)
    SetPlayerAnimation(playerid, "SIT05")
end)

AddCommand("sit6", function(playerid)
    SetPlayerAnimation(playerid, "SIT06")
end)

AddCommand("sit7", function(playerid)
    SetPlayerAnimation(playerid, "SIT07")
end)
