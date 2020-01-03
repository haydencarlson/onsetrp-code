local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end
local Camera = ImportPackage('camera')
local jobMenu
local cameraPaths = {
    delivery = {
        hasCamera = true,
        path = {
            { 212920, 174392, 1891.3470458984, 351.61010742188, 155.78399658203, 0.0 },
            { 208279, 170326, 1891, 359.83453369141, 180.45664978027, 0.0 },
            { 202945, 170302, 1306, 359.83453369141, 180.45664978027, 0.0 } 
        }
    },
    thief = {
        hasCamera = true,
        path = {
            { 212920, 174392, 1891.3470458984, 351.61010742188, 155.78399658203, 0.0 },
            { 209403.109375, 173807.421875,1891.3470458984, 351.61010742188, 90, 0.0 },
            { 208963.21875, 196842.828125, 1891.3470458984, 351.61010742188, 155.78399658203, 0.0 },
            { 192152.0, 196790.296875, 1370.7709960938, 351.61010742188, 155.78399658203, 0.0},
            { 191964.53125, 197376.484375, 1370.9660644531, 351.61010742188, 90, 0.0}
        }
    },
    mechanic = {
        hasCamera = false
    },
    medic = {
        hasCamera = false
    },
    police = {
        hasCamera = true,
        path = {
            { 212920, 174392, 1891.3470458984, 351.61010742188, 155.78399658203, 0.0 },
            { 208046.15625, 173644.90625, 1891.3470458984, 351.61010742188, 155, 0.0 },
            { 198663.125, 173578.765625, 1891.3470458984, 351.61010742188, 155.78399658203, 0.0 },
            { 197285.9375, 196433.140625, 1891.3470458984, 351.61010742188, 155, 0.0},
            { 168819.6875, 196039.703125, 1370.9660644531, 351.61010742188, 155, 0.0},
            { 169544.28125, 191640.640625, 1307.5906982422, 351.61010742188, 350, 0.0}
        }
    }
}
function SelectingJob(key)
    if key == "E" and not onCharacterCreation then
        local NearestNpc = GetNearestNpc()
        if NearestNpc ~= 0 then
	        CallRemoteEvent("JobGuyInteract", NearestNpc)
		end
    end
end

function SelectedJob(selection, playerjob)
    if playerjob ~= "" then
        local stopaction = {
            police = function() 
                CallRemoteEvent("StopPoliceJob")
            end,
            medic = function()
                CallRemoteEvent("StopMedicJob")
            end,
            delivery = function()
                CallRemoteEvent("StartStopDelivery")
            end,
            thief = function()
                CallRemoteEvent("StopThiefJob")
            end,
            mechanic = function()
                CallRemoteEvent("StopMechanicJob")
            end
        }
        stopaction[playerjob]()
    end
    local action = {
        medic = function() 
            CallRemoteEvent("StartMedicJob")
        end,
        delivery = function() SetPlayerClothingPreset(GetPlayerId(), 5) end,
        police = function() 
            CallRemoteEvent("StartPoliceJob")
        end,
        thief = function()
            CallRemoteEvent("StartThiefJob")
        end,
        mechanic = function()
            CallRemoteEvent("StartMechanicJob")
        end
    }   
    action[selection]()       
end

AddRemoteEvent("SelectedJob", SelectedJob)
AddEvent("OnKeyPress", SelectingJob)
AddRemoteEvent("JobGuySetup", function(JobGuyObject)
    JobNpcIds = JobGuyObject
end)

AddRemoteEvent("RPNotify:CameraTutorial", function(selection) 
    if onCharacterCreation and cameraPaths[selection]['hasCamera'] == true and cameraPaths[selection]['path'] ~= nil then
        Camera.StartCameraPath(cameraPaths[selection]['path'], 6000)  
        IsJobCameraDone()
        onCharacterCreation = false
    else
        SetIgnoreMoveInput(false)
        SetInputMode(INPUT_GAME)
        onCharacterCreation = false
        CallRemoteEvent("ShowJobInformation")
    end
end)

function IsJobCameraDone()
    local camera_running = Camera.IsCameraEnabled()
    if camera_running then
        Delay(100, function() 
            IsJobCameraDone()
        end)
    else
        SetIgnoreMoveInput(false)
        SetInputMode(INPUT_GAME)
        CallRemoteEvent("ShowJobInformation")
    end
end

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
