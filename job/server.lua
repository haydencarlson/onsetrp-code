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
        long_desc = 'As a delivery driver you will be driving the work vehichle and completing deliveries. See your GPS for the location.'
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
    CallRemoteEvent(player, "CUI:Close", "job_selection", true)
    CallRemoteEvent(player, "SelectedJob", selection)
    CallRemoteEvent(player, "MakeNotification", "Your new job: " .. selection, "linear-gradient(to right, #00b09b, #96c93d)")
    CallRemoteEvent(player, "CUI:Create", "job_information", selection .. " job")
    CallRemoteEvent(player, "CUI:AddText", selection, text[selection]['long_desc'])
    CallRemoteEvent(player, "CUI:Show", "job_information", true)
    PlayerData[player].job = selection
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

AddRemoteEvent("CUI:OptionClick_job_menu", JobSelected)

AddEvent("OnNPCDamage", function(npc)
    SetNPCHealth( npc, 100 )
end)



