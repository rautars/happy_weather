-- Turn off lightning mod 'auto mode'
lightning.auto = false

local thunder = {}

-- Weather identification code
thunder.code = "thunder"

local thunder_target_weather_code = "heavy_rain"
-- 
-- Happy Weather: Thunder

-- License: MIT

-- Credits:
-- * xeranas

-- Manual triggers flags
local manual_trigger_start = false
local manual_trigger_end = false

-- Thunder weather appearance control
local thunder_weather_chance = 5 -- 5 percent appearance during heavy rain
local thunder_weather_next_check = 0
local thunder_weather_check_delay = 600 -- to avoid checks continuously

thunder.about_to_start = function(dtime)
	if manual_trigger_start then
		manual_trigger_start = false
		return true
	end

	if thunder_weather_next_check > os.time() then
		return
  	end

	if happy_weather.is_weather_active(thunder_target_weather_code) then
		local random_roll = math.random(0,100)
		thunder_weather_next_check = os.time() + thunder_weather_check_delay
		if random_roll <= thunder_weather_chance then
	  		return true
		end
  	end
	return false
end

thunder.about_to_end = function(dtime)
	if manual_trigger_end then
		manual_trigger_end = false
		return true
	end

	if happy_weather.is_weather_active(thunder_target_weather_code) == false then
		return true
	end

	return false
end

local calculate_thunder_strike_delay = function()
	local delay = math.random(thunder.min_delay, thunder.max_delay)
	thunder.next_strike = os.time() + delay
end

thunder.setup = function(dtime)
	checked = false
	thunder.next_strike = 0
	thunder.min_delay = 5
	thunder.max_delay = math.random(5, 45)
end

thunder.update = function(dtime, player)
	if thunder.next_strike <= os.time() then
		lightning.strike()
		calculate_thunder_strike_delay()
	end
end

thunder.manual_trigger_start = function()
	manual_trigger_start = true
end

thunder.manual_trigger_end = function()
	manual_trigger_end = true
end

happy_weather.register_weather(thunder)