local rob = false
local robbers = {}

RegisterServerEvent('esx_traphouse:tooFar')
AddEventHandler('esx_traphouse:tooFar', function(currentTrap)
	local _source = source
	local xPlayers = QBCore.Functions.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
            TriggerClientEvent("QBCore:Notify", xPlayers[i], string.format("~r~The robbery at ~b~%s~s~ has been cancelled!", Traps[currentTrap].nameOfTrap), "error",5000)
			TriggerClientEvent('esx_traphouse:killBlip', xPlayers[i])
	end

	if robbers[_source] then
		TriggerClientEvent('esx_traphouse:tooFar', _source)
		robbers[_source] = nil
        TriggerClientEvent("QBCore:Notify", _source, string.format("~r~The robbery at ~b~%s~s~ has been cancelled!", Traps[currentTrap].nameOfTrap), "error",5000)
	end
end)

RegisterServerEvent('esx_traphouse:dead')
AddEventHandler('esx_traphouse:dead', function(currentTrap)
	local _source = source
	local xPlayers = QBCore.Functions.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
            TriggerClientEvent("QBCore:Notify", xPlayers[i], string.format("~r~The robbery at ~b~%s~s~ has been cancelled!", Traps[currentTrap].nameOfTrap), "error",5000)
			TriggerClientEvent('esx_traphouse:killBlip', xPlayers[i])
	end

	if robbers[_source] then
		TriggerClientEvent('esx_traphouse:playerDead', _source)
		robbers[_source] = nil
        TriggerClientEvent("QBCore:Notify", _source, string.format("~r~The robbery at ~b~%s~s~ has been cancelled!", Traps[currentTrap].nameOfTrap), "error",5000)
	end
end)

RegisterServerEvent('esx_traphouse:robberyStarted')
AddEventHandler('esx_traphouse:robberyStarted', function(currentTrap)
	local _source  = source
	local xPlayer  = QBCore.Functions.GetPlayer(_source)
	local xPlayers = QBCore.Functions.GetPlayers()

	if Traps[currentTrap] then
		local Trap = Traps[currentTrap]

		if (os.time() - Trap.lastRobbed) < Config.TimerBeforeNewRob and Trap.lastRobbed ~= 0 then
            
            TriggerClientEvent("QBCore:Notify", _source, string.format("This trap was recently been robbed. Please wait ~y~%s~s~ seconds until you can rob again",Config.TimerBeforeNewRob - (os.time() - Trap.lastRobbed), "error",5000))
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])

            if (xPlayer.PlayerData.job.name == "police" ) then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= Config.PoliceNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
                    TriggerClientEvent("QBCore:Notify",xPlayers[i], string.format("Yo! Someone is hitting %s!!", Trap.nameOfTrap), "error",5000)
                    
						TriggerClientEvent('esx_traphouse:setBlip', xPlayers[i], Traps[currentTrap].position)
				end
                TriggerClientEvent("QBCore:Notify", _source, string.format("You started to rob %s", Trap.nameOfTrap), "success",5000)

				TriggerClientEvent('esx_traphouse:currentlyRobbing', _source, currentTrap)
				TriggerClientEvent('esx_traphouse:startTimer', _source)

				Traps[currentTrap].lastRobbed = os.time()
				robbers[_source] = currentTrap

				SetTimeout(Trap.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('esx_traphouse:robberyComplete', _source, Trap.reward)
							-- Money rewards.
							if Config.GiveBlackMoney then
                                xPlayer.Functions.AddItem("markedbills", Trap.reward)
								TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items["markedbills"], "add")
							else
                                xPlayer.Functions.AddMoney('cash', Trap.reward)
							end
							-- Drug system rewards
							local chance = math.random(1, 3)
							if chance == 1 then 
								xPlayer.Functions.AddItem("sandwich",1)
								TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items["sandwich"], "add")
							elseif chance == 2 then
								xPlayer.Functions.AddItem("sandwich",1)
								TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items["sandwich"], "add")
							elseif chance == 3 then
								xPlayer.Functions.AddItem("sandwich",1)
								TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items["sandwich"], "add")
							end
							xPlayer.Functions.AddItem("sandwich",math.random(1,5))
							TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items["sandwich"], "add")
							-- xPlayer.Functions.AddItem("sandwich",math.random(1,5))
							-- xPlayer.Functions.AddItem("sandwich",math.random(1,7))		---- ADD MORE LINES LIKE THIS, ALSO PUT DRUGS. IM HUNGRY KTHANKSBYEE
							-- xPlayer.Functions.AddItem("sandwich",math.random(2,5))

							local xPlayers, xPlayer = QBCore.Functions.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
									TriggerClientEvent('QBCore:Notify', xPlayers[i], string.format('obbery successful at %s', Trap.nameOfTrap),"success", 5000)
                                    TriggerClientEvent('QBCore:Notify', _source, string.format('Robbery successful'), "success",5000)
									TriggerClientEvent('esx_traphouse:killBlip', xPlayers[i])
							end
						end
					end
				end)
			else
				TriggerClientEvent('QBCore:Notify', _source, string.format('There must be at least %s cops in town to rob a trap.', Config.PoliceNumberRequired), "error",5000)
			end
		else
            TriggerClientEvent("QBCore:Notify",_source, string.format("A robbery is already in progress!!"), "error",5000)
	
		end
	end
end)