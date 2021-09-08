Config = {}

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 1
Config.TimerBeforeNewRob    = 3600 -- The cooldown timer on a Trap after robbery was completed / canceled, in seconds

Config.MaxDistance    = 15   -- max distance from the robbery, going any longer away from it will to cancel the robbery
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

--To leave available 24/7 set start hour to 00 and end hour to 24
Config.StartHour	= 21 -- 9pm
Config.EndHour		= 07 -- 7am

Traps = {
	["stabcity"] = {
		position = { x = 67.97, y = 3693.42, z = 40.52 },
		reward = math.random(2, 3),
		nameOfTrap = "Stab City Trap",
		secondsRemaining = 360, -- seconds
		lastRobbed = 0
	},
	["windfarm"] = {
		position = { x = 2336.6, y = 2566.24, z = 47.34 },
		reward = math.random(2, 3),
		nameOfTrap = "Wind Farm Trap",
		secondsRemaining = 10, -- seconds
		lastRobbed = 0
	},
	["lighthouse"] = {
		position = { x = 3310.76, y = 5176.27, z = 19.61 },
		reward = math.random(2, 3),
		nameOfTrap = "Lighthouse Trap",
		secondsRemaining = 480, -- seconds
		lastRobbed = 0
	},
	["paleto1"] = {
		position = { x = -356.94, y = 6207.37, z = 31.84 },
		reward = math.random(2, 3),
		nameOfTrap = "Paleto Trap",
		secondsRemaining = 540, -- seconds
		lastRobbed = 0
	},
	["south1"] = {
		position = { x = 388.54, y = -2026.13, z = 23.4 },
		reward = math.random(2, 3),
		nameOfTrap = "Carson Ave Trap",
		secondsRemaining = 360, -- seconds
		lastRobbed = 0
	},
	["forum"] = {
		position = { x = -32.35, y = -1446.41, z = 31.89 },
		reward = math.random(2, 3),
		nameOfTrap = "Forum Dr Trap",
		secondsRemaining = 360, -- seconds
		lastRobbed = 0
	},
	["mirror1"] = {
		position = { x = 979.27, y = -716.44, z = 58.22 },
		reward = math.random(2, 3),
		nameOfTrap = "Mirror Park Trap",
		secondsRemaining = 360, -- seconds
		lastRobbed = 0
	},
	["vespucci"] = {
		position = { x = -1076.38, y = -1026.73, z = 4.54 },
		reward = math.random(2, 3),
		nameOfTrap = "Vespucci Canals Trap",
		secondsRemaining = 360, -- seconds
		lastRobbed = 0
	}
}