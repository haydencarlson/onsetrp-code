AddCommand("workout", function(playerid)
    if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
    local x, y, z = GetPlayerLocation(playerid)
         SetPlayerAnimation(playerid, "PUSHUP_START")	
               Delay(1500, function(player) SetPlayerAnimation(playerid, "PUSHUP_IDLE")
        end)
               Delay(5000, function(player) SetPlayerAnimation(playerid, "PUSHUP_END")
        end)
         Delay(6000, function(player) if GetPlayerArmor(playerid) < 5.0 then
            SetPlayerArmor(playerid, 15.0)
        else
                return
            end
        end)
        Delay(6000, function(player) removePlayerThirst(playerid, 25)
         end)
    end
end)

    AddCommand("stop", function(playerid)
        if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "STOP")
        end
    end)
    
    AddRemoteEvent("handsup", function(player, up, type)
        if up then
            if type == 1 and not GetPlayerPropertyValue(player, 'dead') and not GetPlayerPropertyValue(player, 'cuffed') then
                SetPlayerAnimation(player, 'HANDSUP_STAND')
            else
                SetPlayerAnimation(player, 'HANDSHEAD_KNEEL')
            end
        else
            SetPlayerAnimation(player, 'STOP')
        end
    
    end)

    AddCommand("puke", function(playerid)
        if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "VOMIT")
        end
    end)
    
    AddCommand("salute", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SALUTE")
          end
    end)
    
    AddCommand("thumbsup", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "THUMBSUP")
          end
    end)
    
    AddCommand("crazy", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CRAZYMAN")
          end
    end)
    
    AddCommand("yikes", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DARKSOULS")
          end
    end)
    
    AddCommand("smoking", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SMOKING")
          end
    end)
    
    AddCommand("clap", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CLAP")
          end
    end)
    
    AddCommand("bow", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "BOW")
          end
    end)
    
    AddCommand("stretch", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "STRETCH")
          end
    end)
    
    AddCommand("wave", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WAVE")
          end
    end)
    
    AddCommand("wave2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WAVE2")
          end
    end) 
    
    AddCommand("dab", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DABSAREGAY")
          end
    end)
    
    AddCommand("crossarms", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CROSSARMS")
          end
    end)
    
    AddCommand("dontknow", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DONTKNOW")
          end
    end)
    
    AddCommand("dustoff", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DUSTOFF")
          end
    end)
    
    AddCommand("facepalm", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "FACEPALM")
          end
    end)
    
    AddCommand("flex", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "FLEXX")
          end
    end)
    
    AddCommand("dontlisten", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "IDONTLISTEN")
          end
    end)
    
    AddCommand("justright", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "ITSJUSTRIGHT")
          end
    end)
    
    AddCommand("fallonknees", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "FALLONKNEES")
          end
    end)
    
    AddCommand("kungfu", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "KUNGFU")
          end
    end)
    
    AddCommand("callme", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CALLME")
          end
    end)
    
    AddCommand("shoosh", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SHOOSH")
          end
    end)
    
    AddCommand("slapass", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SLAPOWNASS")
          end
    end)
    
    AddCommand("slapass2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SLAPOWNASS2")
          end
    end)
    
    AddCommand("throatslit", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "THROATSLIT")
          end
    end)
    
    AddCommand("wave3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WAVE3")
          end
    end)
    
    AddCommand("sweating", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WIPEOFFSWEAT")
          end
    end)
    
    AddCommand("guards", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CALL_GUARDS")
          end
    end)
    
    AddCommand("call", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CALL_SOMEONE")
          end
    end)
    
    AddCommand("call2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CALL_SOMEONE2")
          end
    end)
    
    AddCommand("checkeq", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CHECK_EQUIPMENT")
          end
    end)
    
    AddCommand("checkeq2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CHECK_EQUIPMENT2")
          end
    end)
    
    AddCommand("checkeq3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CHECK_EQUIPMENT3")
          end
    end)
    
    AddCommand("clap2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CLAP2")
          end
    end)
    
    AddCommand("clap3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CLAP3")
          end
    end)
    
    AddCommand("cheer", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CHEER")
          end
    end)
    
    AddCommand("drunk", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DRUNK")
          end
    end)
    
    AddCommand("fixstuff", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "FIX_STUFF")
          end
    end)
    
    AddCommand("gethere", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "GET_HERE")
          end
    end)
    
    AddCommand("gethere2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "GET_HERE2")
          end
    end)
    
    AddCommand("goaway", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "GOAWAY")
          end
    end)
    
    AddCommand("laugh", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAUGH")
          end
    end)
    
    AddCommand("thinking", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "THINKING")
          end
    end)
    
    AddCommand("throw", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "THROW")
          end
    end)
    
    AddCommand("salute2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SALUTE2")
          end
    end)
    
    AddCommand("triumph", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "TRIUMPH")
          end
    end)
    
    AddCommand("windows", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WASH_WINDOWS")
          end
    end)
    
    AddCommand("watching", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WATCHING")
          end
    end)
    
    AddCommand("revive", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "REVIVE")
          end
    end)
    
    AddCommand("crossarms2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "CROSSARMS2")
          end
    end)
    
    AddCommand("shrug", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SHRUG")
          end
    end)
    
    AddCommand("yawn", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "YAWN")
          end
    end)
    
    AddCommand("handshake", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "HANDSHAKE")
          end
    end)
    
    AddCommand("fishing", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "FISHING")
          end
    end)
    
    AddCommand("smoking2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SMOKING01")
          end
    end)
    
    AddCommand("smoking3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SMOKING02")
          end
    end)
    
    AddCommand("smoking4", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SMOKING03")
          end
    end)
    
    AddCommand("lean", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WALLLEAN01")
          end
    end)
    
    AddCommand("lean2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WALLLEAN02")
          end
    end)
    
    AddCommand("lean3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WALLLEAN03")
          end
    end)
    
    AddCommand("lean4", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "WALLLEAN04")
          end
    end)
    
    AddCommand("dance", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE01")
          end
    end)
    
    AddCommand("dance2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE02")
          end
    end)
    
    AddCommand("dance3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE03")
          end
    end)
    
    AddCommand("dance4", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE04")
          end
    end)
    
    AddCommand("dance5", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE05")
          end
    end)
    
    AddCommand("dance6", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE06")
          end
    end)
    
    AddCommand("dance7", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE07")
          end
    end)
    
    AddCommand("dance8", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE08")
          end
    end)
    
    AddCommand("dance9", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE09")
          end
    end)
    
    AddCommand("dance10", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE10")
          end
    end)
    
    AddCommand("dance11", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE11")
          end
    end)
    
    AddCommand("dance12", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE12")
          end
    end)
    
    AddCommand("dance13", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE13")
          end
    end)
    
    AddCommand("dance14", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE14")
          end
    end)
    
    AddCommand("dance15", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE15")
          end
    end)
    
    AddCommand("dance16", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE16")
          end
    end)
    
    AddCommand("dance17", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE17")
          end
    end)
    
    AddCommand("dance18", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE18")
          end
    end)
    
    AddCommand("dance19", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE19")
          end
    end)
    
    AddCommand("dance20", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "DANCE20")
          end
    end)
    
    AddCommand("lay", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY01")
          end
    end)
    
    AddCommand("lay2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY02")
          end
    end)
    
    AddCommand("lay3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY03")
          end
    end)
    
    AddCommand("lay4", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY04")
          end
    end)
    
    AddCommand("lay5", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY05")
          end
    end)
    
    AddCommand("lay6", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY06")
          end
    end)
    
    AddCommand("lay7", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY07")
          end
    end)
    
    AddCommand("lay8", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY08")
          end
    end)
    
    AddCommand("lay9", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY09")
          end
    end)
    
    AddCommand("lay10", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY10")
          end
    end)
    
    AddCommand("lay11", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY11")
          end
    end)
    
    AddCommand("lay12", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY12")
          end
    end)
    
    AddCommand("lay13", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY13")
          end
    end)
    
    AddCommand("lay14", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY14")
          end
    end)
    
    AddCommand("lay15", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY15")
          end
    end)
    
    AddCommand("lay16", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY16")
          end
    end)
    
    AddCommand("lay17", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY17")
          end
    end)
    
    AddCommand("lay18", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "LAY18")
          end
    end)
    
    AddCommand("sit", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SIT01")
          end
    end)
    
    AddCommand("sit2", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SIT02")
          end
    end)
    
    AddCommand("sit3", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SIT03")
          end
    end)
    
    AddCommand("sit4", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SIT04")
          end
    end)
    
    AddCommand("sit5", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SIT05")
          end
    end)
    
    AddCommand("sit6", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SIT06")
          end
    end)
    
    AddCommand("sit7", function(playerid)
          if not GetPlayerPropertyValue(playerid, 'dead') and not GetPlayerPropertyValue(playerid, 'cuffed') then
        SetPlayerAnimation(playerid, "SIT07")
          end
    end)
    