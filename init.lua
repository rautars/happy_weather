---------------------------------------
-- Happy Weather: initialization

-- License: MIT

-- Credits: xeranas
---------------------------------------

local modpath = minetest.get_modpath("happy_weather");

-- Turn off lightning mod 'auto mode'
lightning.auto = false

-- Utilities / Helpers
dofile(modpath.."/utils.lua")

-- Weathers
dofile(modpath.."/light_rain.lua")
dofile(modpath.."/rain.lua")
dofile(modpath.."/heavy_rain.lua")
dofile(modpath.."/thunder.lua")
dofile(modpath.."/light_snow.lua")
dofile(modpath.."/snow.lua")
dofile(modpath.."/snowstorm.lua")

dofile(modpath.."/abm.lua")