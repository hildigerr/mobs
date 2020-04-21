--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local modpath = minetest.get_modpath("mobs")

mobs = {
    barf =
        function(level, action, name, position, reason)
            local barf_setting = minetest.settings:get("mobs.barf") or "disabled"
            if barf_setting ~= "disabled" then
                if barf_setting ~= "info" then
                    minetest.chat_send_all(string.format("[mobs] %s %s at %s (%s)", action, name, position, reason))
                end
                if barf_setting ~= "barf" then
                    minetest.log(level, string.format("mobs : %s : %s : %s : %s", reason, action, name, position))
                end
            end
        end
}

dofile(modpath.."/api.lua")
dofile(modpath.."/drops/meat.lua")
dofile(modpath.."/drops/bad_meat.lua")
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
