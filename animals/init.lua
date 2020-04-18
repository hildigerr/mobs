--------------------------------ANIMALS-----------------------------------------
local modpath = minetest.get_modpath("animals")

dofile(modpath.."/cow.lua")
dofile(modpath.."/rabbit.lua")
dofile(modpath.."/racoon.lua")
dofile(modpath.."/rat.lua")
dofile(modpath.."/sheep.lua")

minetest.log("verbose", "mobs animals loaded")
