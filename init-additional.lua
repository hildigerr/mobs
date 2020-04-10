--------------------------------------------------------------------------------
--
--		Additional mobs to extend upon
--			PilzAdam's Simple Mobs <http://minetest.net/forum/viewtopic.php?id=3063>
--
-- Includes:
--		Animals -- Cow (and milk), Rabbit
--		Overcooking and using the result to make dye
--		Meat spoilage if it remains uncooked
--		Cages for Rodents, They will die wihout food and water
--
--NOTES:
--			Raw meet can be preserved through "cheating" or using a refridgerator
--			provided by VanessaE's Home Decor Mod
--				<http://minetest.net/forum/viewtopic.php?id=2041>
--
--			Known bugs:
--				drinking from a stack of vessels does not return an empty vessel
--				cages are sometimes placed sideways or upsidedown
--
--  Written by wulfsdad  -- January 2013 -- WTFPL -- Version 0.4
--------------------------------------------------------------------------------
----Aditional TODO:
--HIGH PRIORITY:
--		support more food, --check balance-- [cheese]
--		add fresh meat and remove rotten meat litter periodically
--MED PRIORITY:
--		add more animals, (chicken/eggs),(pigs/piglets[catchable])
--		fork mobs and add ai tweaks and rebalances, and for animals:
--			breeding & extinction possibility
--		add monsters,
--		cows lift head in water and when walking sometimes
--LOW PRIORITY:
--		add sound effect variety
--		cows "eat" grass
--------------------------------------------------------------------------------
----CONFIG OPTIONS:					[true --or-- false]
--Animals:
local USE_COWS = true
local USE_RABBITS = true
local USE_RACOONS = true
--Msc:
local MEAT_ROTS = true
local ALLOW_OVER_COOKING = true
local USE_CAGES = true
--------------------------------------------------------------------------------

--------------------------------ANIMALS-----------------------------------------
if USE_COWS then
	dofile(minetest.get_modpath("my_mobs").."/animals/cow.lua")
end

if USE_RABBITS then
	dofile(minetest.get_modpath("my_mobs").."/animals/rabbit.lua")
end

if USE_RACOONS then
dofile(minetest.get_modpath("my_mobs").."/animals/racoon.lua")
end

----------------------------------MSC-------------------------------------------
--	These files generally have further config options
if ALLOW_OVER_COOKING then
	dofile(minetest.get_modpath("my_mobs").."/msc/overcook.lua")
end

if MEAT_ROTS then
	dofile(minetest.get_modpath("my_mobs").."/msc/bad_meat.lua")
end

if USE_CAGES then
	dofile(minetest.get_modpath("my_mobs").."/msc/pet_cages.lua")
end

-------------------------------------EOF----------------------------------------
