-- 
-- Happy Weather: Heavy Rain

-- License: MIT

-- Credits:
-- * xeranas

local heavy_rain = {}

-- Weather identification code
heavy_rain.code = "heavy_rain"

-- Keeps sound handler references
local sound_handlers = {}

-- Manual triggers flags
local manual_trigger_start = false
local manual_trigger_end = false

-- Skycolor layer id
local SKYCOLOR_LAYER = "happy_weather_heavy_rain_sky"

heavy_rain.about_to_start = function(dtime)
	if manual_trigger_start then
		manual_trigger_start = false
		return true
	end
	
	return false
end

heavy_rain.about_to_end = function(dtime)
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
		{r=65, g=66, b=78},
		{r=112, g=110, b=119},
		{r=65, g=66, b=78},
		{r=0, g=0, b=0}})
	skycolor.active = true
end

local set_rain_sound = function(player) 
	return minetest.sound_play("heavy_rain_drop", {
		object = player,
		max_hear_distance = 2,
		loop = true,
	})
end

local remove_rain_sound = function(player)
	local sound = sound_handlers[player:get_player_name()]
	if sound ~= nil then
		minetest.sound_stop(sound)
		sound_handlers[player:get_player_name()] = nil
	end
end

heavy_rain.setup = function(player)
	sound_handlers[player:get_player_name()] = set_rain_sound(player)
	set_sky_box()
end

heavy_rain.clear_up = function(player)
	remove_rain_sound(player)
	skycolor.remove_layer(SKYCOLOR_LAYER)
end

local rain_drop_texture = "happy_weather_heavy_rain_drops.png"

local add_close_range_rain_particle = function(player)
	local offset = {
		front = 1,
		back = 0,
		top = 2
	}

	local random_pos = hw_utils.get_random_pos(player, offset)
	local rain_texture_size_offset_y = -1

	if hw_utils.is_outdoor(random_pos, rain_texture_size_offset_y) then
		minetest.add_particle({
		  pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
		  velocity = {x=0, y=-10, z=0},
		  acceleration = {x=0, y=-10, z=0},
		  expirationtime = 5,
		  size = 30,
		  collisiondetection = true,
		  collision_removal = true,
		  vertical = true,
		  texture = rain_drop_texture,
		  playername = player:get_player_name()
		})
	end
end

local add_wide_range_rain_particle = function(player)
	local offset = {
		front = 10,
		back = 5,
		top = 8
	}

	local random_pos = hw_utils.get_random_pos(player, offset)

	if hw_utils.is_outdoor(random_pos) then
		minetest.add_particle({
		  pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
		  velocity = {x=0, y=-10, z=0},
		  acceleration = {x=0, y=-15, z=0},
		  expirationtime = 5,
		  size = 30,
		  collisiondetection = true,
		  collision_removal = true,
		  vertical = true,
		  texture = rain_drop_texture,
		  playername = player:get_player_name()
		})
	end
end

local display_rain_particles = function(player)
	if hw_utils.is_underwater(player) then
		return
	end

	add_close_range_rain_particle(player)
  
	local particles_number_per_update = 5
	for i=particles_number_per_update, 1,-1 do
		add_wide_range_rain_particle(player)
	end
end

heavy_rain.update = function(dtime, player)
	display_rain_particles(player)
end

heavy_rain.manual_trigger_start = function()
	manual_trigger_start = true
end

heavy_rain.manual_trigger_end = function()
	manual_trigger_end = true
end

happy_weather.register_weather(heavy_rain)

-- ABM for extinguish fire
minetest.register_abm({
	nodenames = {"fire:basic_flame"},
	interval = 4.0,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if heavy_rain.active and hw_utils.is_outdoor(pos) then
			minetest.remove_node(pos)
		end
	end
})
