AddCommand("job", function(player, ...)
local args = { ... }
   if args == "medic" then return
	AddPlayerChat(player,  message)
	else
	message = '<span color="#">You switch jobs to medic</> '
	  AddPlayerChat(player,  message)
	end
end)
