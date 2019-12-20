local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local jobMenu

function SelectingJob(key)
    if key == "F5" and not onSpawn and not onCharacterCreation then
        CallRemoteEvent("ServerJobDialog")
    end
end

function SelectedJob(selection)
    local action = {
        medic = function() SetPlayerClothingPreset(GetPlayerId(), 17) end,
        delivery = function() SetPlayerClothingPreset(GetPlayerId(), 5) end
    }   
    action[selection]()       
end

function OnTranslationReady()
    jobMenu = Dialog.create(_("job_menu"), "Select your job", "Create", "Cancel")
end

function OpenJobSelectDialog()
    Dialog.show(jobMenu)
end

AddRemoteEvent("SelectedJob", SelectedJob)
AddEvent("OnTranslationReady", OnTranslationReady)
AddRemoteEvent("OpenJobSelectDialog", OpenJobSelectDialog)
AddEvent("OnKeyPress", SelectingJob)