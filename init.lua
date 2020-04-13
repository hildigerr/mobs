--------------------------------------------------------------------------------
----CONFIG OPTIONS:                    [true --or-- false]
local MEAT_ROTS = minetest.settings:get_bool("mobs.meat_rots", true)
local ALLOW_OVER_COOKING = minetest.settings:get_bool("mobs.overcooking", true)
local USE_CAGES = minetest.settings:get_bool("mobs.cages", true)
--------------------------------------------------------------------------------
local modpath = minetest.get_modpath("mobs")
dofile(modpath.."/api.lua")
dofile(modpath.."/msc/meat.lua")

-------------------------------MONSTERS-----------------------------------------
dofile(modpath.."/monsters/dirt_monster.lua")
dofile(modpath.."/monsters/dungeon_master.lua")
dofile(modpath.."/monsters/oerkki.lua")
dofile(modpath.."/monsters/sand_monster.lua")
dofile(modpath.."/monsters/stone_monster.lua")
dofile(modpath.."/monsters/tree_monster.lua")

--------------------------------ANIMALS-----------------------------------------
dofile(modpath.."/animals/cow.lua")
dofile(modpath.."/animals/rabbit.lua")
dofile(modpath.."/animals/racoon.lua")
dofile(modpath.."/animals/rat.lua")
dofile(modpath.."/animals/sheep.lua")

--------------------------------------------------------------------------------
if ALLOW_OVER_COOKING then
    dofile(minetest.get_modpath("mobs").."/msc/overcook.lua")
end

if MEAT_ROTS then
    dofile(minetest.get_modpath("mobs").."/msc/bad_meat.lua")
end

if USE_CAGES then
    dofile(minetest.get_modpath("mobs").."/msc/pet_cages.lua")
end

if minetest.setting_get("log_mods") then
    minetest.log("action", "mobs loaded")
end
