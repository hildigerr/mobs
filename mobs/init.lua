--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local modpath = minetest.get_modpath("mobs")

minetest.log("info", "loading mobs")

dofile(modpath.."/api.lua")
dofile(modpath.."/drops/meat.lua")
dofile(modpath.."/drops/milk.lua")
dofile(modpath.."/drops/carrot.lua")

