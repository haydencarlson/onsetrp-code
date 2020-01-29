local Laws = {}

AddEvent("OnPackageStart", function()
    CallEvent("default_laws")
end)

AddEvent("default_laws", function()
    CallEvent("SetLaws", "1", "No jaywalking.", "Fine: 100$")
    CallEvent("SetLaws", "2", "No heavy weapons allowed.", "Arrest: 2 mins")
    CallEvent("SetLaws", "3", "Handguns allowed with licence", "Fine: 500$")
    CallEvent("SetLaws", "4", "Drug use is illegal", "Fine: 200$")
    CallEvent("SetLaws", "5", "Drug procressing is illegal", "Arrest: 2 mins")
    CallEvent("SetLaws", "6", "Selling drugs is illegal", "Arrest: 2 mins")
    CallEvent("SetLaws", "7", "Raping other players is illegal", "Arrest: 2 mins")
    CallEvent("SetLaws", "8", "Robbing other players is illegal.", "Arrest: 2 mins")
    CallEvent("SetLaws", "9", "Selling stolen silver bars is illegal.", "Arrest: 2 mins")
    CallEvent("SetLaws", "10", "Speed Limit in cities is 40 KM/H.", "Fine: 150$")
    CallEvent("SetLaws", "11", "Speed Limit outside cities is 75 KM/H.", "Fine: 150$")
    CallEvent("SetLaws", "12", "Stealing vehicles is illegal.", "Arrest: 2 mins")
end)

AddEvent("SetLaws", function(lawid, law, action)
    table.insert(Laws, {
        law_name = law,
        action = action,
        id = #Laws + 1
    })
end)


local function FindLaw(id) 
    for k, v in pairs(Laws) do
        if tonumber(v['id']) == tonumber(id) then
            return k
        end
    end
end

AddCommand("setlaw", function(player, lawid, action, ...)
    local law = table.concat({...}, " ") 
    if action == "arrest" then
        action = "Arrest: 2 mins"
    elseif action == "fine100" then
        action = "Fine: 100$"
    elseif action == "fine200" then
        action = "Fine: 200$"
    elseif action == "fine300" then
        action = "Fine: 300$"
    elseif action == "fine400" then
        action = "Fine: 400$"
    elseif action == "fine500" then
        action = "Fine: 500$"
    end

    if PlayerData[player].job == "mayor"  then
        if tonumber(lawid) > 12 or tonumber(lawid) < 0 or lawid == nil or #{...} == 0 then
            return AddPlayerChat(player, "Usage: /setlaw [LawID 1-12] [arrest, fine100, fine200, fine300, fine400, fine500] [Law]")
        else
            local lawKey = FindLaw(lawid)
            Laws[lawKey]['law_name'] = law
            Laws[lawKey]['action'] = action
            CallRemoteEvent(player, 'KNotify:Send', "Law #" .. lawid .. " has been updated.", "#0f0")
            AddPlayerChatAll(law .. ". The mayor has passed a new law. Check the laws with TAB to see the laws penalty")
            
        end
    else
        AddPlayerChat(player, "You must be a mayor to do this.")
        end  
    end)
--[[     
AddCommand("removelaw", function(player, lawid)
    if PlayerData[player].job == "mayor"  then
        if tonumber(lawid) > 12 or tonumber(lawid) < 0 or lawid == nil then
            return AddPlayerChat(player, "Usage: /removelaw [LawID 1-12]")
        else
            local lawKey = FindLaw(lawid)
            table.remove(Laws, lawKey)
            -- Laws[lawKey] = nil
        end
    else
        AddPlayerChat(player, "You must be a mayor to do this.")
        end  
    end)
    ]]
AddEvent("OnPlayerDeath", function(player)
    if PlayerData[player].job == 'mayor' then
        PlayerData[player].job = 'citizen'
        IsMayor = false
        CallRemoteEvent(player, "RPNotify:HUDEvent", "job", "citizen")
        AddPlayerChatAll("The mayor: ".. GetPlayerName(player) .." has died.")
        CallEvent("default_laws")
    end
end)

AddRemoteEvent("StartMayorJob", function(player)
    if PlayerData[player].job ~= 'mayor' then
        PlayerData[player].job = 'mayor'
    end
end)

AddRemoteEvent("StopMayorJob", function(player)
    if PlayerData[player].job == 'mayor' then
        PlayerData[player].job = 'citizen'
        IsMayor = false
        CallEvent("default_laws")
    end
end)

AddRemoteEvent("RequestScoreboardLaws", function(player) 
    local laws = json_encode(Laws)
    CallRemoteEvent(player, "OnServerLawUpdate", laws)
end)