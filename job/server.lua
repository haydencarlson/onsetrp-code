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
    medic = {
        short_desc = 'Providing services to the injured',
        long_desc = 'As a medic you will be in charge of helping the injured. When someone needs your help go help them!'
    },
    delivery = {
        short_desc = 'Deliver packages to earn your pay',
        long_desc = 'Travel to the delivery job, you can find it on your GPS. As a delivery driver you will be driving the work vehicle and completing deliveries. See your GPS for the location.'
    },
    police = {
        short_desc = "Become a police officer",
        long_desc = "Press F3 to bring up the police officer menu. Travel to the police station to get your car (You can use GPS). As a police officer your job will require you to bring criminal activitiy to a halt. Using your tools provided help put a stop to robberies, shooting and other criminal activities."
    },
    thief = {
        short_desc = "Mug and Rob to make your living",
        long_desc = "Push F3 to open your thief menu. Use the tools of your trade to rob and collect cash. Get caught, go to jail. High risk, high reward."
    },
    mechanic = {
        short_desc = "In charge of repairing vehicles",
        long_desc = "Push F3 to open your mechanic menu. When you are near a car you can select repair vehicle to repair the players vehicle."
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

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "JobGuySetup", NpcID)
end)


AddRemoteEvent("JobGuyInteract", function(player, jobguyid)
	if jobguyid then
		local x, y, z = GetNPCLocation(jobguyid)
		local x2, y2, z2 = GetPlayerLocation(player)
        local dist = GetDistance3D(x, y, z, x2, y2, z2)
		if dist < 250 then
            ShowSelectJob(player)
		end
	end
end)

function GetJobGuyByObject(jobguyobject)
	for k,v in pairs(JobsTable) do
		if v.npc == jobguyobject then
			return v
		end
	end
	return nil
end

function JobSelected(player, selection)
    PlayerData[player].job = ""
    CallRemoteEvent(player, "CUI:Close", "job_selection", true)
    CallRemoteEvent(player, "SelectedJob", selection, PlayerData[player].job)
    if selection ~= "police" then
        CallRemoteEvent(player, "MakeNotification", "Your new job: " .. selection, "linear-gradient(to right, #00b09b, #96c93d)")
    end
    CallRemoteEvent(player, "CUI:Create", "job_information", selection .. " job")
    CallRemoteEvent(player, "CUI:AddText", selection, text[selection]['long_desc'])
    CallRemoteEvent(player, "CUI:AddOption", 'Close', 'Read above', 'Read the information provided for your job', 'Close')
    CallRemoteEvent(player, "RPNotify:HUDEvent", "job", selection)
    CallRemoteEvent(player, "RPNotify:CameraTutorial", selection)
end

function CloseJobInformation(player)
    CallRemoteEvent(player, "CUI:Close", "job_information", true)
end

function ShowSelectJob(player) 
    CallRemoteEvent(player, "CUI:Create", "job_menu", "Jobs")
    local i = 1;
    for k, v in pairs(text) do
        i = i + 1;
        CallRemoteEvent(player, "CUI:AddOption", k, k, v['short_desc'], "Select")
    end
    CallRemoteEvent(player, "CUI:Show", "job_selection", true)
end

AddRemoteEvent("ShowJobInformation", function(player)
    CallRemoteEvent(player, "CUI:Show", "job_information", true)
end)

AddRemoteEvent("ShowSelectJob", ShowSelectJob)
AddRemoteEvent("CUI:OptionClick_job_menu", JobSelected)
AddRemoteEvent("CUI:OptionClick_job_information", CloseJobInformation)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)



