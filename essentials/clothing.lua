function cmd_hat(player, hatobject)
	if (PlayerData[player].hat ~= 0) then
		DestroyObject(tostring(PlayerData[player].hat))
		PlayerData[player].hat = 0
	end

	local hatModel = 0

	if hatobject == nil then
		local startHats = 398
		local endHats = 477

		hatModel = Random(startHats, endHats)
    else
        if tonumber(hatobject) > 397 and tonumber(hatobject) < 478 then 
        hatModel = math.tointeger(hatobject)
        else
           return AddPlayerChat(player, "Hat ID must be between 398 and 477.")
        end
	end

    local x, y, z = GetPlayerLocation(player)
    PlayerData[player].hatmodel = tonumber(hatModel)
    PlayerData[player].hat = CreateObject(hatModel, x, y, z)
    if tonumber(IsSupporter(player)) == 1 or tonumber(IsRank(player)) > 0 then
        if hatobject ~= nil then
            if tonumber(hatobject) == 398 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.5, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 399 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 400 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 14.0, 3.4, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 401 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 17.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 402 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 17.0, 3, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 403 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 404 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 405 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 406 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 12.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 407 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 408 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 409 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 410 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 411 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 412 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 17.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 413 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 14.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 414 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.5, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 415 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 16.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 416 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 417 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end-- above this line is fitted
            if tonumber(hatobject) == 418 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 16.5, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 419 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 420 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 16.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 421 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 422 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.5, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 423 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.5, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 424 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 17.0, 3.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 425 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 3.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 426 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 427 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 16.5, 3.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 428 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 3.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 429 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 3.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 430 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 16.5, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 431 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 17.0, 2.5, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 432 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 16.5, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 433 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 12.0, 3.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 434 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 16.5, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 435 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 12.5, 8.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 436 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 14.5, 6.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 437 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 438 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 439 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 440 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 441 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 442 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 443 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 2.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 444 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 445 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 0.0, 1.0, 2.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 446 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.5, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 447 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.5, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 448 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 12.5, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 449 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 12.5, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 450 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 451 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 11.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 452 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.5, 0.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 453 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.5, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 454 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.5, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 455 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.5, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 456 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.5, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 457 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 458 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 11.0, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 459 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.0, 1.0, 1.0, 4.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 460 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.5, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 461 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 15.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 462 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 463 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.5, 3.0, 0.0, 0.0, 100.0, -90.0, "head")
            end
            if tonumber(hatobject) == 464 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 14.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 465 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 466 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 9.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 467 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 9.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 468 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 14.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 469 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 12.0, 0.0, 0.0, 0.0, 88.0, -90.0, "head")
            end
            if tonumber(hatobject) == 470 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 12.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 471 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 9.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 472 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.0, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 473 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.0, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 474 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 10.0, 1.5, 0.0, 0.0, 45.0, -90.0, "head")
            end
            if tonumber(hatobject) == 475 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.0, 1.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 476 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
            if tonumber(hatobject) == 477 then
                SetObjectAttached(PlayerData[player].hat, ATTACH_PLAYER, player, 13.0, 0.0, 0.0, 0.0, 90.0, -90.0, "head")
            end
        
        end
    else
        AddPlayerChat(player, "Your rank must be supporter to do this. ")
    end
end
AddCommand("hat", cmd_hat)

function cmd_remove_hat(player)
    if tonumber(IsSupporter(player)) == 1 or tonumber(IsRank(player)) > 0 then
        DestroyObject(PlayerData[player].hat)
    end
end
AddCommand("remove_hat", cmd_remove_hat)

AddEvent("OnPlayerDeath", function(player) 
    cmd_remove_hat(player)
end)

AddEvent("OnPlayerSpawn", function(player) 
    Delay(5000, function(player)
        cmd_hat(player, PlayerData[player].hatmodel)
    end, player)
end)