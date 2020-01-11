local inside = false
local last_check = false
local refreshTimer = 0

local pressed = false

local Stores = nil

local Robbing = false
local currentRobbery = 0

function OnPackageStart()
	Stores = Config.Stores
	refreshTimer = CreateTimer(CheckInRobbery, 100)
end
AddEvent("OnPackageStart", OnPackageStart)


function CheckInRobbery()
	
	inside = false
	local x,y,z = GetPlayerLocation()
	local distance = 0

	currentRobbery = 0

	local i = 1
	for _ in pairs(Stores) do
		if not inside then
			if GetDistance3D(x,y,z,Stores[i].x, Stores[i].y, Stores[i].z) <= 125 then
				distance = GetDistance3D(x,y,z,Stores[i].x, Stores[i].y, Stores[i].z)
				inside = true

				if not Robbing then
					if not pressed then
 						CallEvent("KNotify:SendPress", "Press [E] to start a robbery")
 					else
 						CallEvent("KNotify:SendPress", "Press [E] again to start a robbery")
 					end
				end

				currentRobbery = i
			end
		end
		i = i + 1
	end

	if last_check and not inside then
		CallEvent("KNotify:HidePress")
	end
	last_check = inside
end

function OnKeyPress(key)
	if key == "E" and inside and not GetPlayerPropertyValue(GetPlayerId(), 'cuffed') and not GetPlayerPropertyValue(GetPlayerId(), 'dead') then
		if pressed then
			StartRobbery()
			pressed = false
		else
			pressed = true
			Delay(2000, function ()
				pressed = false
			end)
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function StartRobbery()
	if currentRobbery ~= 0 and not Robbing then
		CallRemoteEvent("Kuzkay:RobberiesLaunch", currentRobbery)
	end
end

function ConfirmStart()
	Robbing = true
	CallEvent('KNotify:HidePress')
end
AddRemoteEvent("Kuzkay:RobberiesConfirmStart", ConfirmStart)

function StopRobbery()
	Robbing = false
end
AddRemoteEvent("Kuzkay:RobberiesStop", StopRobbery)