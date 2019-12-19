
local jobs = { 
    medic = 'Providing services to the injured',
    delivery = 'Deliver packages to earn your pay'
}

function JobSelected(player, selection)
    if selection == 'medic' then
        print('selected medic')
    end
end

function ShowSelectJob(player) 

    CallRemoteEvent(player, "KUI:Create", "job_menu", "Jobs")
    local i = 1;
    for k, v in pairs(jobs) do
        i = i + 1;
        CallRemoteEvent(player, "KUI:AddOption", k, k, v, "Select")
    end
    CallRemoteEvent(player, "KUI:Show", "job_selection", true)
end

AddRemoteEvent("KUI:OptionClick_job_menu", JobSelected)
AddRemoteEvent("ServerJobDialog", ShowSelectJob)

