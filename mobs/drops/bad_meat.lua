---------------------------------SPOILING MEAT----------------------------------
if not minetest.settings:get_bool("mobs.meat_rots", false) then return end
local use_homedecor = minetest.get_modpath("homedecor")

local CHANCE_ROT_POCKET = tonumber(minetest.settings:get("mobs.meat_chance_rot_inventory")) or 33
local CHANCE_ROT_STORAGE = tonumber(minetest.settings:get("mobs.meat_chance_rot_storage")) or 50
local CHANCE_ROT_COOKING = tonumber(minetest.settings:get("mobs.meat_chance_rot_cooking")) or 66

local POCKET_TIMER  = 60 * (tonumber(minetest.settings:get("mobs.meat_timer_rot_inventory")) or 5)
local STORAGE_TIMER = 60 * (tonumber(minetest.settings:get("mobs.meat_timer_rot_storage")) or 10)
local COOKING_TIMER = 60 * (tonumber(minetest.settings:get("mobs.meat_timer_rot_cooking")) or 20)
--------------------------------------------------------------------------------

function spoil_meat( inv, title, chance, warn, owner )
--inv = InvRef
--title = listname (string)-- TODO: make handle lists
--chance = [1-100]
--warn = boolean
--owner = player name (string)
    for i=1,inv:get_size(title) do
        local item = inv:get_stack(title, i)
        if item:get_name() == "mobs:meat_raw" then
            local qt = item:get_count()
            local rotted = 0
            for j=1,qt do
                if math.random(1,100) <= chance then
                    rotted = rotted +1
                end
            end
            if rotted ~= 0 then
                local stack = ItemStack({name="mobs:meat_rotten", count=rotted, wear=0, metadata=""})
                if rotted < qt and inv:room_for_item(title, stack) then
                    item:take_item(rotted)
                    inv:add_item(title, stack)
                else -- (rotted == qt) or not enough room so rot it all:
                    item:replace({name = "mobs:meat_rotten", count = qt, wear=0, metadata=""})
                end
                inv:set_stack(title, i, item)
                if warn then
                    minetest.sound_play("ugh_rot_warn", {to_player = owner})
                    -- TODO: Have multiple strings to choose from randomly:
                    minetest.chat_send_player(owner, "Something in your inventory is starting to smell bad!")
                end
                mobs.barf("info", "meat", "rotted", title, owner or "xxx")
            end
        end
    end
end


--Rot Stored Meat
if CHANCE_ROT_STORAGE > 0 then
    minetest.register_abm({
        nodenames = not use_homedecor and {
            "default:chest",
            "default:chest_locked"
        } or {
            "default:chest",
            "default:chest_locked",
            "homedecor:kitchen_cabinet",
            "homedecor:kitchen_cabinet_half",
            "homedecor:kitchen_cabinet_with_sink",
            "homedecor:nightstand_oak_one_drawer",
            "homedecor:nightstand_oak_two_drawers",
            "homedecor:nightstand_mahogany_one_drawer",
            "homedecor:nightstand_mahogany_two_drawers",
        },
        interval = STORAGE_TIMER,
        chance = 1,
        action = function(pos, node)
            spoil_meat(minetest.get_meta(pos):get_inventory(), "main", CHANCE_ROT_STORAGE)
        end
    })
end

--Rot Cooking Meat
if CHANCE_ROT_COOKING > 0 then
    minetest.register_abm({
        nodenames = not use_homedecor and {"default:furnace"}
            or {"default:furnace", "homedecor:oven"},
        interval = COOKING_TIMER,
        chance = 1,
        action = function(pos, node)
            spoil_meat(minetest.get_meta(pos):get_inventory(), "src", CHANCE_ROT_COOKING)
        end
    })
end


--Rot Held Meat
if CHANCE_ROT_POCKET > 0 then
local rotting_timer = 0
minetest.register_globalstep( function(dtime)
    rotting_timer = rotting_timer + dtime
    if rotting_timer >= POCKET_TIMER then
        for _,player in ipairs(minetest.get_connected_players()) do
            local who = player:get_player_name()
            local stuff = player:get_inventory()
            spoil_meat(stuff, "main", CHANCE_ROT_POCKET, true, who)
            spoil_meat(stuff, "craft", CHANCE_ROT_POCKET, true, who)
        end -- for each player
        rotting_timer = 0 --reset the timer
    end -- timer
end)
end

-------------------------------------EOF----------------------------------------
