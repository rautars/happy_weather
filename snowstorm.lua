-- 
-- Happy Weather: Snowfall

-- License: MIT

-- Credits:
-- * xeranas

local snowstorm = {}

-- Weather identification code
snowstorm.code = "snowstorm"

-- Keeps sound handler references
local sound_handlers = {}

-- Manual triggers flags
local manual_trigger_start = false
local manual_trigger_end = false

-- Skycolor layer id
local SKYCOLOR_LAYER = "happy_weather_snowstorm_sky"

snowstorm.about_to_start = function(dtime)
	if manual_trigger_start then
		manual_trigger_start = false
		return true
	end
	
	return false
end

snowstorm.about_to_end = function(dtime)
	if manual_trigger_end then
		manual_trigger_end = false
		return true
	end

	return false
end

local set_sky_box = function()
	skycolor.add_layer(
		SKYCOLOR_LAYER,
		{{r=0, g=0, b=0},
		{r=70, g=70, b=85},
		{r=120, g=120, b=125},
		{r=70, g=70, b=85},
		{r=0, g=0, b=0}})
	skycolor.active = true
end

snowstorm.setup = function(player)
	set_sky_box()
end

snowstorm.clear_up = function(player)
	skycolor.remove_layer(SKYCOLOR_LAYER)
end

local rain_drop_texture = "happy_weather_snowstorm.png"

local sign = function (number)
	if number >= 0 then
		return 1
	else
		return -1
	end
end

local add_wide_range_rain_particle = function(player)
	local offset = {
		front = 7,
		back = 4,
		top = 3,
		bottom = 0
	}

	local random_pos = hw_utils.get_random_pos(player, offset)
	local p_pos = player:getpos()

	local look_dir = player:get_look_dir()

	if hw_utils.is_outdoor(random_pos) then
		minetest.add_particle({
			pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
		  	velocity = {x = sign(look_dir.x) * -10, y = -1, z = sign(look_dir.z) * -10},
		  	acceleration = {x = sign(look_dir.x) * -10, y = -1, z = sign(look_dir.z) * -10},
		  	expirationtime = 0.3,
		  	size = 30,
		  	collisiondetection = true,
		  	texture = "happy_weather_snowstorm.png",
		  	playername = player:get_player_name()
		})
	end
end

local display_rain_particles = function(player)
	if hw_utils.is_underwater(player) then
		return
	end

	local particles_number_per_update = 3
	for i=particles_number_per_update, 1,-1 do
		add_wide_range_rain_particle(player)
	end
end

snowstorm.update = function(dtime, player)
	display_rain_particles(player)
end

snowstorm.manual_trigger_start = function()
	manual_trigger_start = true
end

snowstorm.manual_trigger_end = function()
	manual_trigger_end = true
end

happy_weather.register_weather(snowstorm)

