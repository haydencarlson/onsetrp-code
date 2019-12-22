local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local jobMenu

function SelectingJob(key)
    if key == "E" and not onCharacterCreation then
        local NearestNpc = GetNearestNpc()
        if NearestNpc ~= 0 then
	        CallRemoteEvent("JobGuyInteract", NearestNpc)
		end
    end
end

function SelectedJob(selection)
    local action = {
        medic = function() SetPlayerClothingPreset(GetPlayerId(), 17) end,
        delivery = function() SetPlayerClothingPreset(GetPlayerId(), 5) end
    }   
    action[selection]()       
end

AddRemoteEvent("SelectedJob", SelectedJob)
AddEvent("OnKeyPress", SelectingJob)
AddRemoteEvent("JobGuySetup", function(JobGuyObject)
    JobNpcIds = JobGuyObject
end)

function GetNearestNpc()
	local x, y, z = GetPlayerLocation()
    for k,v in pairs(GetStreamedNPC()) do
        local x2, y2, z2 = GetNPCLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)
        if dist < 250.0 then
            for k,i in pairs(JobNpcIds) do
				if v == i then
					return v
				end
			end
		end
	end
	return 0
end
