local holdingUp = false
local Trap = ""
local blipTraphouse = nil
local isDead = false

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


AddEventHandler('esx:onPlayerDeath', function(data)
    if Player.metadata["inlaststand"] or Player.metadata["isdead"] then

    TriggerServerEvent('esx_traphouse:dead', Trap)
    end
end)
function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	if outline then SetTextOutline() end

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
RegisterNetEvent('esx_traphouse:currentlyRobbing')
AddEventHandler('esx_traphouse:currentlyRobbing', function(currentTrap)
	holdingUp, Trap = true, currentTrap
end)

RegisterNetEvent('esx_traphouse:killBlip')
AddEventHandler('esx_traphouse:killBlip', function()
	RemoveBlip(blipTraphouse)
end)

RegisterNetEvent('esx_traphouse:setBlip')
AddEventHandler('esx_traphouse:setBlip', function(position)
	blipTraphouse = AddBlipForCoord(position.x, position.y, position.z)

	SetBlipSprite(blipTraphouse, 161)
	SetBlipScale(blipTraphouse, 2.0)

	PulseBlip(blipTraphouse)
end)

RegisterNetEvent('esx_traphouse:tooFar')
AddEventHandler('esx_traphouse:tooFar', function()
	holdingUp, Trap = false, ''
    local _source = source
        TriggerClientEvent("QBCore:Notify", _source, string.format("The robbery has been cancelled!"), "error",5000)
end)

RegisterNetEvent('esx_traphouse:playerDead')
AddEventHandler('esx_traphouse:playerDead', function()
	holdingUp, Trap = false, ''
    local _source = source
        TriggerClientEvent("QBCore:Notify", _source, string.format("The robbery has been cancelled!"), "error",5000)
end)

RegisterNetEvent('esx_traphouse:robberyComplete')
AddEventHandler('esx_traphouse:robberyComplete', function(award)
	holdingUp, Trap = false, ''
    local _source = source
	QBCore.Functions.Notify(string.format("The robbery has been successful, you stole $%s", award), success, 5000)
        --TriggerClientEvent("QBCore:Notify", _source, string.format("~r~The robbery has been successful~s~, you ~o~stole~s~ ~g~$%s~s~", award), "success",5000)
end)

RegisterNetEvent('esx_traphouse:startTimer')
AddEventHandler('esx_traphouse:startTimer', function()
	local timer = Traps[Trap].secondsRemaining

	Citizen.CreateThread(function()
		while timer > 0 and holdingUp do
			Citizen.Wait(1000)

			if timer > 0 then
				timer = timer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while holdingUp do
			Citizen.Wait(0)
			drawTxt(0.85, 1.44, 1.0, 1.0, 0.4, "Trap robbery: ~r~" .. math.ceil(timer) .. "~w~ more seconds", 255, 255, 255, 255)
		end
	end)
end)

Citizen.CreateThread(function()
	for k,v in pairs(Traps) do
		local blip = AddBlipForCoord(v.position.x, v.position.y, v.position.z)
		SetBlipSprite(blip, 514)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Trap Robbery')
		EndTextCommandSetBlipName(blip)
	end
end)                       

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		hour = GetClockHours()
		if (hour >= Config.StartHour and hour <= 24) or  (hour <= Config.EndHour and hour >= 00) then
			for k,v in pairs(Traps) do
				local TrapPos = v.position
				local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, TrapPos.x, TrapPos.y, TrapPos.z)

				if distance < 5 then
					if not holdingUp then
						--DrawMarker(Config.Marker.Type, TrapPos.x, TrapPos.y, TrapPos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, false, false, false, false)
                        DrawText3D(TrapPos.x, TrapPos.y, TrapPos.z, "~r~Trap Robbery~r~")
						if distance < 0.5 then

							if IsControlJustReleased(0, Keys['E']) then
								if IsPedArmed(PlayerPedId(), 4) then
									TriggerServerEvent('esx_traphouse:robberyStarted', k)
								else
                                    QBCore.Functions.Notify("You Pose No Threat", "error", 5000)
								end
							end
						end
					end
				end
			end
		end
		
		if holdingUp then
			local TrapPos = Traps[Trap].position
			if Vdist(playerPos.x, playerPos.y, playerPos.z, TrapPos.x, TrapPos.y, TrapPos.z) > Config.MaxDistance then
				TriggerServerEvent('esx_traphouse:tooFar', Trap)
			end
		end
	end
end)