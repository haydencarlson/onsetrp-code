local GPSlocations = {
	{name="Cocaine farm", show=false, locations={
		{x=-220692,y=-85078,z=187}
	}},
	{name="Cocaine Lab", show=false, locations={
		{x=-177203,y=3759,z=2009}
	}},
	{name="Known Acetone location", show=false, locations={
		{x=-186594,y=-36751,z=1148}
	}},
	{name="Known Opium Poppy Field", show=false,locations={
		{x=130085,y=177023,z=1381}
	}},
	{name="Known Calcium location", show=false,locations={
		{x=137745,y=209936,z=1292}
	}},
	{name="Heroin Lab", show=false, locations={
		{x=-5992,y=118385,z=1387}
	}},
	{name="Acomore", show=true, locations={
		{x=162725,y=205080,z=1358}
	}},
	{name="Tesno", show=true, locations={
		{x=-19525,y=-6205,z=2062}
	}},
	{name="Pinewood", show=true, locations={
		{x=-169735, y=-38014, z=1146}
	}},
	{name="Steveville", show=true, locations={
		{x=42081,y=135863,z=1572}
	}},

	{name="Nearest Store", show=true, locations={
		{x=128765,y=77854,z=1577},
		{x=42650,y=138188,z=1581},
		{x=-15391,y=-2588,z=2065},
		{x=-168934,y=-39183,z=1149},
		{x=42678,y=137926,z=1581},
		{x=49288,y=133307,z=1578}
	}},
	{name="Nearest Weapon Store", show=true, locations={
		{x=-181761,y=-40668,z=1163},
		{x=206067,y=193102,z=1357}
	}},
	{name="Nearest Garage", show=true, locations={
		{x=128153,y=75993,z=1566},
		{x=-170162,y=-36975,z=1146},
		{x=175674,y=203230,z=1308},
		{x=-15861,y=-8101,z=2062}
	}},
	{name="Nearest Car Dealership",show=true, locations={
		{x=-189001,y=-52181,z=1148},
		{x=173150,y=212774,z=1282}
	}},
	{name="Nearest ATM",show=true,locations={
		{x=-181944 ,y=-40246,z=1163},
		{x=129099,y=77949,z=1576},
		{x=-15091,y=-2416,z=2065},
		{x=43783,y=133267,z=1569},
		{x=42244,y=137938,z=1581},
		{x=-189247,y=-51745,z=1148},
		{x=212899,y=190039,z=1309},
		{x=213426,y=190578,z=1309}
	}},
	{name="Nearest Job Center",show=true,locations={
		{x=164082,y=205865,z=1358},
		{x=-15507,y=-4068,z=2062},
		{x=-169911,y=-38935,z=1146}
	}}
}  

local  myNumber = 0

local open = false
local ui = 0
function OnPackageStart()
	Delay(1500, function()
		ui = CreateWebUI(0, 0, 0, 0, 5, 40)
		LoadWebFile(ui, "http://asset/onsetrp/phone/gui/_phone.html")
		SetWebAlignment(ui, 0.0, 0.0)
		SetWebAnchors(ui, 0.0, 0.0, 1.0, 1.0)
		SetWebVisibility(ui, WEB_HIDDEN)
	end)
	
end
AddEvent("OnPackageStart", OnPackageStart)

local myJob = ""

AddRemoteEvent("OnJobChange", function(job, grade)
	myJob = job
end)

AddEvent("Kuzkay:PhoneLoaded", function()
	CallRemoteEvent("Kuzkay:GetPhoneNumber")
	ExecuteWebJS(ui, "ClearTweets();")

	for k,v in pairs(GPSlocations) do
		if v.show then
			ExecuteWebJS(ui, "AddGPS('"..v.name.."','".. k .."','".. 0 .."','".. 0 .."');")
		end
	end

end)

local cooldown = false
local cooldown2 = false

function OnKeyPress(key)
	if key == "K" and not GetPlayerPropertyValue(GetPlayerId(), 'cuffed') and (not UIOpen or open == true) then
		TogglePhone()
		cooldown = false
		cooldown2 = false
	end
	if key == "Escape" then
		if open then
			UIOpen = false
			open = false
			SetWebVisibility(ui, WEB_HIDDEN)
			SetIgnoreLookInput(false)
			ShowMouseCursor(false)
			SetInputMode(INPUT_GAME)
			CallRemoteEvent("Kuzkay:PlayAnim", "PHONE_PUTAWAY")
		end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function TogglePhone()
	open = not open
	if open then
		UIOpen = true		
		SetWebVisibility(ui, WEB_VISIBLE)
		SetIgnoreLookInput(true)
		ShowMouseCursor(true)
		SetInputMode(INPUT_GAMEANDUI)
		CallRemoteEvent("Kuzkay:PlayAnim", "PHONE_TAKEOUT")
	else
		UIOpen = false
		SetWebVisibility(ui, WEB_HIDDEN)
		SetIgnoreLookInput(false)
		SetIgnoreMoveInput(false)
		ShowMouseCursor(false)
		SetInputMode(INPUT_GAME)
		CallRemoteEvent("Kuzkay:PlayAnim", "PHONE_PUTAWAY")
	end
end

function SetInputFocus(bool)
	if bool == "true" then
		SetIgnoreMoveInput(true)
		SetInputMode(INPUT_UI)
	else
		SetIgnoreMoveInput(false)
		if open then
			SetInputMode(INPUT_GAMEANDUI)
		end
	end
end
AddEvent("Kuzkay:PhoneInputFocus", SetInputFocus)

function SetPlayerNumber(number)
	myNumber = number
	AddPlayerChat(number)
	
	ExecuteWebJS(ui, "SetMyNumber('"..number.."');")
end
AddRemoteEvent("Kuzkay:PhoneSetClientNumber", SetPlayerNumber)

local waypoints = {}
function SetLocationWaypoint(name,x,y,z)
	if name ~= "Location" then
		local nearest = 0
		local nearestDist = 9999999

		local px,py,pz = GetPlayerLocation()
		for k,v in pairs(GPSlocations[tonumber(x)].locations) do

			if nearestDist > GetDistance3D(px,py,pz, v.x, v.y, v.z) then
				nearest = v
				nearestDist = GetDistance3D(px,py,pz, v.x, v.y, v.z)
			end

		end

		x = nearest.x
		y = nearest.y
		z = nearest.z
	end

	if waypoints[name] ~= nil then
		DestroyWaypoint(waypoints[name])
		waypoints[name] = nil
	else
		if nearest ~= 0 then
			waypoints[name] = CreateWaypoint(x,y,z,name)
		end
	end
end
AddEvent("Kuzkay:PhoneSetLocation", SetLocationWaypoint)


function SetCooldown()
	cooldown = true
	Delay(1500, function()
		cooldown = false
	end)
end



function SetCooldown2()
	cooldown2 = true
	Delay(1500, function()
		cooldown2 = false
	end)
end

function AddContact(number, name)
	if not cooldown then
		CallRemoteEvent("Kuzkay:PhoneAddContact", number, name)
		SetCooldown()
	else
		CallEvent("KNotify:Send", "Wait before doing this again", "#f00")
	end
end
AddEvent("Kuzkay:PhoneAddContact", AddContact)

function InsertContact(number, name)
	ExecuteWebJS(ui, "AddContact("..number..",'"..name.."');")
end
AddRemoteEvent("Kuzkay:PhoneInsertContact", InsertContact)

function SendTweet(text)
	if not cooldown then
		CallRemoteEvent("Kuzkay:PhoneSendTweet", text)
		SetCooldown()
	else
		CallEvent("KNotify:Send", "Wait before doing this again", "#f00")
	end
end
AddEvent("Kuzkay:PhoneTweet", SendTweet)

function RecieveTweet(sender, text)
	ExecuteWebJS(ui, "AddTweet('"..sender.."','"..text.."');")
end
AddRemoteEvent("Kuzkay:PhoneRecieveTweet", RecieveTweet)


function SendMessage(number, text)
	if not cooldown then
		CallRemoteEvent("Kuzkay:PhoneSendMessage", number, text)
		SetCooldown()
	else
		CallEvent("KNotify:Send", "Wait before doing this again", "#f00")
	end
end
AddEvent("Kuzkay:PhoneMessage", SendMessage)


function RecieveMessage(sender, senderNumber, number, text)
	number = math.floor(tonumber(number))
	if text == nil then
		return
	end

	if number == tonumber(myNumber) or sender == GetPlayerId() then

		if sender == GetPlayerId() then
			ExecuteWebJS(ui, "AddMessage("..number..",'"..text.."','sent');")
		else
			ExecuteWebJS(ui, "AddMessage("..senderNumber..",'"..text.."','recieved');")

			if GetWebVisibility(ui) == WEB_HIDDEN then
				local sound = CreateSound("utils/vibration.wav")
				Delay(1000, function()
					DestroySound(sound)
				end)
			end
		end

		
	else
		if (number == 999 and myJob == "police") or (number == 998 and myJob == "ems") or (number == 911 and (myJob == "police" or myJob == "ems")) then
			ExecuteWebJS(ui, "AddMessage("..number..",'"..text.."','job');")

			if GetWebVisibility(ui) == WEB_HIDDEN then
				local sound = CreateSound("utils/vibration.wav")
				Delay(1000, function()
					DestroySound(sound)
				end)
			end

		end
	end
end
AddRemoteEvent("Kuzkay:PhoneRecieveMessage", RecieveMessage)

function DeleteContact(number)
	CallRemoteEvent("Kuzkay:PhoneDeleteContact", number)
end
AddEvent("Kuzkay:PhoneDeleteContact", DeleteContact)


function SendLocationMessage(number)
	if not cooldown2 then
		CallRemoteEvent("Kuzkay:PhoneSendLocationMessage", number)
		SetCooldown2()
	else
		CallEvent("KNotify:Send", "Wait before doing this again", "#f00")
	end
end
AddEvent("Kuzkay:PhoneLocationMessage", SendLocationMessage)

function RecieveLocationMessage(sender, senderNumber, number, x, y, z)
	number = math.floor(tonumber(number))
	if tonumber(number) == tonumber(myNumber) or sender == GetPlayerId() then
		if sender == GetPlayerId() then
			ExecuteWebJS(ui, "AddLocationMessage("..number..","..x..","..y..","..z..");")
		else
			ExecuteWebJS(ui, "AddLocationMessage("..senderNumber..","..x..","..y..","..z..");")
		end
	else
		if ((number == 999 and myJob == "police") or (number == 998 and myJob == "ems") or (number == 911 and (myJob == "police" or myJob == "ems"))) then
			ExecuteWebJS(ui, "AddLocationMessage("..number..","..x..","..y..","..z..");")
		end
	end
end
AddRemoteEvent("Kuzkay:PhoneRecieveLocationMessage", RecieveLocationMessage)