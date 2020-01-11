local numbers = {}

local contacts = {}

AddRemoteEvent("Kuzkay:GetPhoneNumber", function(player)
	GetPhoneNumber(player)
end)

AddEvent("OnPlayerQuit", function(player)
	numbers[player] = nil
end)

function GetPhoneNumber(player)
	local query = mariadb_prepare(sql, "SELECT `phone_number` FROM `accounts` WHERE `steamid` = '?' LIMIT 1;",
		tostring(GetPlayerSteamId(player))
	)
	mariadb_query(sql, query, PhoneNumberLoaded, player)
end

function PhoneNumberLoaded(player)
	if mariadb_get_row_count() ~= 0 then
		local result = mariadb_get_assoc(1)
		if result['phone_number'] ~= nil then
			numbers[player] = tonumber(result['phone_number'])
			CallRemoteEvent(player, "Kuzkay:PhoneSetClientNumber", tonumber(result['phone_number']))
			GetPlayerContacts(player)
		else
			CreateNewNumber(player)
		end
	else
		CreateNewNumber(player)
		GetPlayerContacts(player)
	end
end

function CreateNewNumber(player)

	local number = GenerateNumber()
	print("new number")
	print(tostring(number))
	local query = mariadb_prepare(sql, "UPDATE `accounts` SET `phone_number` = '?' WHERE `steamid` = '?';",
		number,
		tostring(GetPlayerSteamId(player))
	)
			
	mariadb_query(sql, query, PhoneNumberCreated, player, number)
end

function PhoneNumberCreated(player, number)
	numbers[player] = tonumber(number)
	CallRemoteEvent(player, "Kuzkay:PhoneSetClientNumber", number)
	print("Successfully created a phone number for " .. GetPlayerName(player) .. " #" .. number)
end


function GenerateNumber()
	local got = false
	local number = ""

	local attempt = 1
	while not got and attempt < 50 do
		attempt = attempt + 1
		
	    number = ""
	    number = math.random(110000,999999)

		if CheckNumberFree(number) then
			got = true
		end
	end

	return number
end


function AddContact(player, number, name)
	if #contacts[player] <= 20 then
		local query = mariadb_prepare(sql, "INSERT INTO `phone_contacts` (`steamid`, `number`, `name`) VALUES ('?', '?', '?', '?');",
			tostring(GetPlayerSteamId(player)),
			tonumber(number),
			name
		)

		mariadb_query(sql, query, OnContactAdded, player)
		CallRemoteEvent(player, "KNotify:Send", "Contact has been added", "#0f0");
	else
		CallRemoteEvent(player, "KNotify:Send", "Contact limit reached(20) Contact won't be saved after relog", "#f00")
	end
end
AddRemoteEvent("Kuzkay:PhoneAddContact", AddContact, player, number, name)

function OnContactAdded(player, number, name)
	local i = #contacts[player] + 1
	contacts[player][i] = {}
	contacts[player][i].name = name
	contacts[player][i].number = number
end

function CheckNumberFree(number)
	local query = mariadb_prepare(sql, "SELECT phone_number FROM `accounts` WHERE `phone_number` = '?';", number)
	mariadb_query(sql, query, function()
		if mariadb_get_row_count() == 0 then
			return true
		else
			return false
		end
	end)
end

function GetPlayerContacts(player)
	local query = mariadb_prepare(sql, "SELECT * FROM `phone_contacts` WHERE `steamid` = '?';",
		tostring(GetPlayerSteamId(player))
	)

	mariadb_query(sql, query, function()
		contacts[player] = {}

		for i = 1, mariadb_get_row_count() do
			local result = mariadb_get_assoc(i)
					
			contacts[player][i] = {}
			contacts[player][i].name = result.name
			contacts[player][i].number = result.number
			CallRemoteEvent(player, "Kuzkay:PhoneInsertContact", result.number, result.name)

			i = i + 1
		end
	end)
end



AddRemoteEvent("Kuzkay:PhoneSendTweet", function(player, text)
	for _, v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v, "Kuzkay:PhoneRecieveTweet", GetPlayerName(player), text)
	end
end)



function SendPlayerMessage(player, number, text)
	for _, v in pairs(GetAllPlayers()) do

		if number == "107113" or number == "104202" then
			BotMessage(player, number, text, "dealer")
			return
		end

		local senderNumber = numbers[player]
		local x,y,z = GetPlayerLocation(v)
		CallRemoteEvent(v, "Kuzkay:PhoneRecieveMessage", player, senderNumber, number, text, x,y,z)
	end
end

AddRemoteEvent("Kuzkay:PhoneSendMessage", SendPlayerMessage)

function SendCustomPlayerMessage(player , sender, number, text)
	for _, v in pairs(GetAllPlayers()) do
		local senderNumber = tonumber(sender)
		local x,y,z = GetPlayerLocation(v)
		CallRemoteEvent(v, "Kuzkay:PhoneRecieveMessage", -1, senderNumber, tonumber(number), text)
	end
end
AddCommand("message", SendCustomPlayerMessage)

AddRemoteEvent("Kuzkay:PhoneSendLocationMessage", function(player , number)
	local x,y,z = GetPlayerLocation(player)
	for _, v in pairs(GetAllPlayers()) do
		local senderNumber = numbers[player]
		
		CallRemoteEvent(v, "Kuzkay:PhoneRecieveLocationMessage", player, senderNumber, number, x,y,z)
	end
end)

AddRemoteEvent("Kuzkay:PhoneDeleteContact", function(player, number)
	local query = mariadb_prepare(sql, "DELETE FROM `phone_contacts` WHERE `steamid` = '?' AND number = '?';",
			tostring(GetPlayerSteamId(player)),
			tonumber(number)
	)

	mariadb_query(sql, query, OnContactDeleted, player)
end)

function OnContactDeleted(player)
	CallRemoteEvent(player, "KNotify:Send", "Contact has been deleted", "#0f0")
end

AddEvent("Kuzkay:PhoneSendToJob", function(job, text,x,y,z)
	for v, v in pairs(GetAllPlayers()) do
		if PlayerData[player].job == job then
			local pNumber = tonumber(numbers[v])
			CallRemoteEvent(v, "Kuzkay:PhoneRecieveMessage", -1, "999", pNumber, text, x,y,z)
			Delay(300, function()
				CallRemoteEvent(v, "Kuzkay:PhoneRecieveLocationMessage", -1, "999", pNumber, x,y,z)
			end)
		end
	end
end)


local botMessages = {
	dealer={
			meet={"Whats up", "Hey", "Yo", "Whatsup", "Wassup", "Mornin", "Welcome"},
			welcome={"What ya need?", "What ya need?", "Wht ya need?", "If youre a cop you can fuck off already", "Talk business or gtfo", "be quick", "What do you need", "Hello?", "Who r you", "Who this?", "What do you want from me.", "?"},
			when={"We can meet rn", "Now is good", "Now", "Right now", "rn", "right fucking now"},
			where={"Right here", "Here", "Come now", "Right here", "Meet me here", "this is the spot", "there", "meet me", "Im here rn", "be quick" },
			feeling={"Im fine", "Im good", "ok, hbu", "just fine", "aight, what do you need", "fine", "alright", "great", "good, what do you want", "what do you need man", "good"},
			price={"Meet me and I will tell ya", "not sharing the bucks on the mobile", "meet me and youll know", "meet me", "do I look like a restaurant?", "come and youll see", "just get yo ass here"},
			deal={"Yeah I got it", "Sure", "I can get what ever you need", "Im selling and buying, meet me", "?", "Talk business", "Get to the point", "I have a lot"},
			unknown={"Wym", "Wym", "What do you mean", "What do you mean", "What?", "What?", "What?", "What?", "What do you want?", "Get straight to the point", "Get straight to the point", "?", "?", "Whut?", "I dont get what you mean"},
			who={"Who is this", "Who tf are you?!", "Who r u", "Whos this?"},
			name={"Jeff", "Fuck off retard", "G-Blok", "Stfu", "You want something or not idiot?", "...", "What the fuck did you ask me?", "Are you retarded?", "Big Bush", "G Blok", "My name is fuck off idiot", "Business or go"},
			love={"Miss me with that gay shit", "Hell naa", "You gay or smthin", "Wym love?", "Im no homo bruv", "Fuck off", "Gay.", "I only love my bed and my momma, Im sorry", "Go away homo", "Ok boomer"},
			easteregg={"SHOT THE FOCK UP M8 I AINT A FOKIN BRIT INIT","FOCK OFF M8","I will shank ya", "Ill shag ja nan", "Want sum tea?", "Ding dong", "Oi mate", "Stop talkin tosh", "Cunt", "Wanna play fortnite?"},
			offense={"Fuck you!", "fuck off", "Get out of here idiot", "Puta madre!", "Idiot", "stfu", "gtfo", "shut yo ass", "go", "frick off"},
			npc={"wym?", "what?", "what do you mean", "what", "no.", "idk what you mean man", "wym, you want something or not?", "do you want business or a friend?", "Im not looking for friends.", "No", "nah", "get to business", "wym man", "?", "huh", "no, why"}
			}
}
local botMemory = {}

function OnPlayerQuit(player)
	local senderNumber = numbers[player]
	if botMemory[senderNumber] ~= nil then
		botMemory[senderNumber] = nil
	end
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function BotMessage(player, number, text, bot)
	local senderNumber = numbers[player]
	local x,y,z = GetPlayerLocation(player)
	CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", player, senderNumber, number, text, x,y,z)
	local str = string.lower(text)

	if bot == "dealer" then
		local delay = 50
		if math.random(0,6) == 1 then
			delay = math.random(7000,27000)
		end

		local loc_text = ""
		for k,v in pairs(GetAllNPC()) do
			if GetNPCPropertyValue(v, "drug_dealer") ~= nil then
				x,y,z = GetNPCLocation(v)
				loc_text = GetNPCPropertyValue(v, "dealer_text")
			end
		end

		Delay(delay, function()
			if (string.match(str, "hey") or string.match(str, "hello") or string.match(str, "hi") or string.match(str, "yo") or string.match(str, "wassup")  or string.match(str, "whatsup") or string.match(str, "whats up") or string.match(str, "good morning") or string.match(str, "im") or string.match(str, "i am") or string.match(str, "i'm") or string.match(str, "my name")) and botMemory[senderNumber] == nil then
				local botMessage = botMessages[bot]['meet'][math.random(1,#botMessages[bot]['meet'])]
				botMemory[senderNumber] = true
				Delay(math.random(9000,22000), function()
					CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					Delay(1800, function()
						local botMessage = botMessages[bot]['welcome'][math.random(1,#botMessages[bot]['welcome'])]
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end)
				end)
				return
			end

			local messageID = math.random(0,99999999)
			if botMemory[senderNumber] ~= nil then
				botMemory[senderNumber] = messageID
			end
			
			if (string.match(str, "when") or string.match(str, "time")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['when'][math.random(1,#botMessages[bot]['when'])]
				Delay(math.random(2500,7000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, "where") or string.match(str, "location") or string.match(str, "position") or string.match(str, "wherabouts")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['where'][math.random(1,#botMessages[bot]['where'])]
				Delay(math.random(5500,16000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage .. ", " .. loc_text , x,y,z)
						Delay(math.random(1000,3000), function()
							CallRemoteEvent(player, "Kuzkay:PhoneRecieveLocationMessage", -1 , number, senderNumber, x,y,z)
						end)
					end
				end)
				return
			end

			if (string.match(str, "much") or string.match(str, "price") or string.match(str, "pay")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['price'][math.random(1,#botMessages[bot]['price'])]
				Delay(2000, function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, "drug") or string.match(str, "interested") or string.match(str, "do you") or string.match(str, "coke") or string.match(str, "weed") or string.match(str, "heroin") or string.match(str, "meth") or string.match(str, "powder") or string.match(str, "got")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['price'][math.random(1,#botMessages[bot]['price'])]
				Delay(math.random(3500, 5000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, "how are y") or string.match(str, "how are u") or string.match(str, "how r u") or string.match(str, "how r y") or string.match(str, "are you doing") or string.match(str, "r you doing") or string.match(str, "r u doing") or string.match(str, "are u doing")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['feeling'][math.random(1,#botMessages[bot]['feeling'])]
				Delay(math.random(3500, 5000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, " name ") or string.match(str, "who are") or string.match(str, "who r ")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['name'][math.random(1,#botMessages[bot]['name'])]
				Delay(math.random(3500, 5000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, "love")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['love'][math.random(1,#botMessages[bot]['love'])]
				Delay(math.random(3500, 5000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, "bonkers") or string.match(str, " tea ")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['easteregg'][math.random(1,#botMessages[bot]['easteregg'])]
				Delay(math.random(3500, 5000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, "fuck you") or string.match(str, "retarded") or string.match(str, "idiot") or string.match(str, "cunt") or string.match(str, "fucker") or string.match(str, "brain dead")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['offense'][math.random(1,#botMessages[bot]['offense'])]
				Delay(math.random(1600, 3000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if (string.match(str, "npc") or string.match(str, "bot") or string.match(str, "you real")) and botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['npc'][math.random(1,#botMessages[bot]['npc'])]
				Delay(math.random(3100, 5000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
				return
			end

			if botMemory[senderNumber] ~= nil then
				local botMessage = botMessages[bot]['unknown'][math.random(1,#botMessages[bot]['unknown'])]
				Delay(math.random(3500, 6000), function()
					if botMemory[senderNumber] == messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
			else
				local botMessage = botMessages[bot]['who'][math.random(1,#botMessages[bot]['who'])]
				Delay(math.random(8000, 12000), function()
					if botMemory[senderNumber] ~= messageID then
						CallRemoteEvent(player, "Kuzkay:PhoneRecieveMessage", -1, number, senderNumber, botMessage, x,y,z)
					end
				end)
			end
		end)
		
	end
end
