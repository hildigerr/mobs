--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local modpath = minetest.get_modpath("mobs")

dofile(modpath.."/api.lua")
dofile(modpath.."/drops/meat.lua")
dofile(modpath.."/drops/milk.lua")
dofile(modpath.."/drops/carrot.lua")

if minetest.get_item_group("default:apple", "eatable") == 0 then
    local groups = minetest.registered_nodes["default:apple"].groups
    groups.eatable = 1
    minetest.override_item("default:apple", {groups=groups})
    minetest.log("action", "mobs : set eatable group : default:apple")
end

if minetest.get_item_group("default:blueberries", "eatable") == 0 then
    local groups = minetest.registered_craftitems["default:blueberries"].groups
    groups.eatable = 1
    minetest.override_item("default:blueberries", {groups=groups})
    minetest.log("action", "mobs : set eatable group : default:blueberries")
end
