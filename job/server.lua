
jobs_table = { 
    medic = {
        short_desc = 'Providing services to the injured',
        long_desc = 'As a medic you will be in charge of helping the injured. When someone needs your help go help them!'
    },
    delivery = {
        short_desc = 'Deliver packages to earn your pay',
        long_desc = 'As a delivery driver you will be driving the work vehichle and completing deliveries. See your GPS for the location.'
    }
}

function JobSelected(player, selection)
    CallRemoteEvent(player, "CUI:Close", "job_selection", true)
    CallRemoteEvent(player, "SelectedJob", selection)
    CallRemoteEvent(player, "MakeNotification", "Your new job: " .. selection, "linear-gradient(to right, #00b09b, #96c93d)")
    CallRemoteEvent(player, "CUI:Create", "job_information", selection .. " job")
    CallRemoteEvent(player, "CUI:AddText", selection, jobs_table[selection]['long_desc'])
    CallRemoteEvent(player, "CUI:Show", "job_information", true)
    PlayerData[player].job = selection
end

function ShowSelectJob(player) 
    CallRemoteEvent(player, "CUI:Create", "job_menu", "Jobs")
    local i = 1;
    for k, v in pairs(jobs_table) do
        i = i + 1;
        CallRemoteEvent(player, "CUI:AddOption", k, k, v['short_desc'], "Select")
    end
    CallRemoteEvent(player, "CUI:Show", "job_selection", true)
end

AddRemoteEvent("CUI:OptionClick_job_menu", JobSelected)
AddRemoteEvent("ServerJobDialog", ShowSelectJob)

