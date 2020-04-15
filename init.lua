--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local modpath = minetest.get_modpath("mobs")
dofile(modpath.."/api.lua")
dofile(modpath.."/msc/meat.lua")
dofile(modpath.."/msc/bad_meat.lua")

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
if minetest.settings:get_bool("mobs.overcooking", true) then
    dofile(modpath.."/msc/overcook.lua")
end

if minetest.setting_get("log_mods") then
    minetest.log("action", "mobs loaded")
end
