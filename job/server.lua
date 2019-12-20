
jobs_table = { 
    medic = 'Providing services to the injured',
    delivery = 'Deliver packages to earn your pay'
}

function JobSelected(player, selection)
    CallRemoteEvent(player, "KUI:Close", "job_selection", true)
    CallRemoteEvent(player, "SelectedJob", selection)
    CallRemoteEvent(player, "MakeNotification", "Your new job: " .. selection, "linear-gradient(to right, #00b09b, #96c93d)")
    PlayerData[player].job = selection
end

function ShowSelectJob(player) 
    CallRemoteEvent(player, "KUI:Create", "job_menu", "Jobs")
    local i = 1;
    for k, v in pairs(jobs_table) do
        i = i + 1;
        CallRemoteEvent(player, "KUI:AddOption", k, k, v, "Select")
    end
    CallRemoteEvent(player, "KUI:Show", "job_selection", true)
end

AddRemoteEvent("KUI:OptionClick_job_menu", JobSelected)
AddRemoteEvent("ServerJobDialog", ShowSelectJob)

