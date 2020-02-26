local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

NpcID = { }
JobsTable = { 
{		location = { 
            {  213055, 174617, 1308, 180 }
        },

        npc = {},
	
    },
}

text = {
    {
        jobName = "medic",
        short_desc = 'Providing services to the injured',
        jobDescription = 'As a medic you will be in charge of helping the injured. When someone needs your help go help them! Push F3 to bring up your medic menu. You can revive someone who died by pushing E',
        jobLimit = 5,
        jobCurrentPlayers = 0
    },
    {
        jobName = "delivery",
        short_desc = 'Deliver packages to earn your pay',
        jobDescription = 'Travel to the delivery npc to start your delivery and get a delivery vehicle.. You can use your own vehicle but you get a truck if you visit a delivery NPC. Once you are at the delivery point select finish delivery from the F3 menu to finish.',
        jobLimit = 0,
        jobCurrentPlayers = 0
    },
    {
        jobName = "police",
        short_desc = "Become a police officer",
        jobDescription = "Travel to the police station to get your car. As a police officer your job will require you to bring criminal activitiy to a halt. Using your tools provided help put a stop to robberies, shooting and other criminal activities.",
        commands = {"/arrest to jail a wanted player", "/want to make a player wanted"},
        jobLimit = 10,
        jobCurrentPlayers = 0
    },
    {
        jobName = "thief",
        short_desc = "Rob stores, people and banks.",
        jobDescription = "Use the tools of your trade to rob and collect cash. Get caught, go to jail. High risk, high reward. Rob banks, players and stores to make cash.",
        commands = {"/rob near a player to rob them"},
        jobLimit = 0,
        jobCurrentPlayers = 0
    },
    {
        jobName = "mechanic",
        short_desc = "In charge of repairing vehicles",
        jobDescription = "When you are near a car you can select repair vehicle to repair the players vehicle. Drive other peoples car into the mechanic mod spot to apply mods to their vehicle. Be sure to get money from them and it will come out of your pocket",
        jobLimit = 0,
        jobCurrentPlayers = 0
    },
    {
        jobName = "cinema",
        short_desc = "In charge of the cinema and playing videos.",
        jobDescription = "You are the Cinema manager, play videos at the cinema. You can charge people money for entry. Look for the cinema on the map. Play youtube videos using your commands",
        commands = {"/play [Video ID]", "/play_fullscreen [Video ID]"},
        jobLimit = 1,
        jobCurrentPlayers = 0
    },
    {
        jobName = "mayor",
        short_desc = "In charge of the city and police force.",
        jobDescription = "You are the Mayor. You control the laws in the world. Use the police department to protect you. When you die you will be removed from office.",
        commands = {"/sawlaw [LawID 1-12] [Penalty (arrest, fine100, fine200, fine300, fine400, fine500)] [The Law]"},
        jobLimit = 1,
        jobCurrentPlayers = 0
    },
    {
        jobName = "hitman",
        short_desc = "Get hired to kill people",
        jobDescription = "As a Hitman people can request you to kill people. Kill people when you are requested not randomly. As a Hitman you receive half up front and half after killing your target.",
        commands = {"Players can hire you with /requesthit amount player_id"},
        jobLimit = 1,
        jobCurrentPlayers = 0
    }
}

AddEvent("OnPackageStart", function()
    for k,v in pairs(JobsTable) do
        for i,j in pairs(v.location) do
            v.npc[i] = CreateNPC(v.location[i][1], v.location[i][2], v.location[i][3], v.location[i][4])
            CreateText3D("Job Manager".."\n".._("press_e"), 18, v.location[i][1], v.location[i][2], v.location[i][3] + 120, 0, 0, 0)
            SetNPCAnimation(v.npc[i], "CHEER", true)
		    table.insert(NpcID, v.npc[i])
        end
	end
end)

function ClearJobPlayers() 
    for jk, j in pairs(text) do
        text[jk]['jobCurrentPlayers'] = 0
    end
end

function AddJobUserLimits() 
    ClearJobPlayers()
    for jk, j in pairs(text) do
        for jp, p in pairs(GetAllPlayers()) do
            if PlayerData[p].job == j.jobName then
                text[jk]['jobCurrentPlayers'] = text[jk]['jobCurrentPlayers'] + 1
            end
        end
    end
end

AddEvent("OnNPCStreamIn", function(npc, player)
    CallRemoteEvent(player, "ChangeJobManagerClothing", NpcID[1], 6)
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "JobGuySetup", NpcID)
    CallRemoteEvent(player, "ChangeJobManagerClothing", NpcID[1], 6)
end)

AddRemoteEvent("JobGuyInteract", function(player)
    AddJobUserLimits()
    CallRemoteEvent(player, "JobSelectionSetup")
    for k, v in pairs(text) do
        CallRemoteEvent(player, "AddJobToJobSelection", v)
    end
    CallRemoteEvent(player, "ShowJobSelection")
end)

function JobSelected(player, selection)
    if selection ~= PlayerData[player].job then
        CallRemoteEvent(player, "SelectedJob", selection, PlayerData[player].job)
        if selection ~= "police" then
            CallRemoteEvent(player, 'KNotify:Send', "Your new job: " .. selection, "#0f0")
        end

        if selection == "cinema" and isCm then
            return
        end
        if selection == "cinema" and isCm ~= true then
            isCm = true
        end

        if selection == "mayor" and IsMayor then
            return
        end
        if selection == "mayor" and IsMayor ~= true then
            IsMayor = true
        end
        CallRemoteEvent(player, "RPNotify:HUDEvent", "job", selection)
        CallRemoteEvent(player, "RPNotify:CameraTutorial", selection)
        
    else
        CallRemoteEvent(player, 'KNotify:Send', "Your job is already: " .. selection, "#f00")
    end
end

AddRemoteEvent("StartDeliveryJob", function(player)
    if PlayerData[player].job ~= "delivery" then
        PlayerData[player].job = "delivery"
    else
        CallRemoteEvent(player, 'KNotify:Send', _("already_delivery_driver"), "#f00")
    end
end)

function CloseJobInformation(player)
    CallRemoteEvent(player, "CUI:Close", "job_information", true)
end

function ShowSelectJob(player)
    CallRemoteEvent(player, "CUI:Create", "job_menu", "Jobs")
    local i = 1;
    for k, v in pairs(text) do
        i = i + 1;
        CallRemoteEvent(player, "CUI:AddOption", k, _(k), v['short_desc'], "Select")
    end
    CallRemoteEvent(player, "CUI:Show", "job_selection", true)
end

AddRemoteEvent("ShowJobInformation", function(player)
    CallRemoteEvent(player, "CUI:Show", "job_information", true)
end)

AddRemoteEvent("ShowSelectJob", ShowSelectJob)
AddRemoteEvent("JobSelected", JobSelected)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)



