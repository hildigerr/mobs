---------------------------------SPOILING MEAT----------------------------------
if not minetest.settings:get_bool("mobs.meat_rots", false) then return end
local use_homedecor = minetest.get_modpath("homedecor")

----CONFIG OPTIONS:
--Chances of meat rotting [1-100]
--if math.random(1,100) <= CHANCE then it will rot
local ROT_IN_POCKET_CHANCE = 33 --DEFAULT:33
local ROT_IN_STORAGE_CHANCE = 33 --DEFAULT:33
local ROT_WHILE_COOKING_CHANCE = 33 --DEFAULT:33

--Time to Rot intervals
--Aproximetley equivalent to seconds
local WATER_TIMER = 240 --DEFAULT:240 [4 min]
local GROUND_TIMER = 360 --DEFAULT:360 [6 min]
local POCKET_TIMER = 720 --DEFAULT:720 [12 min]
local STORAGE_TIMER = 720 --DEFAULT:720 [12 min]
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
if ROT_IN_STORAGE_CHANCE > 0 then
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
            spoil_meat(minetest.get_meta(pos):get_inventory(), "main", ROT_IN_STORAGE_CHANCE)
        end
    })
end

--Rot Cooking Meat
if ROT_WHILE_COOKING_CHANCE > 0 then
    minetest.register_abm({
        nodenames = not use_homedecor and {"default:furnace"}
            or {"default:furnace", "homedecor:oven"},
        interval = STORAGE_TIMER,
        chance = 1,
        action = function(pos, node)
            spoil_meat(minetest.get_meta(pos):get_inventory(), "src", ROT_WHILE_COOKING_CHANCE)
        end
    })
end


--Rot Held Meat
if ROT_IN_POCKET_CHANCE > 0 then
local rotting_timer = 0
minetest.register_globalstep( function(dtime)
    rotting_timer = rotting_timer + dtime
    if rotting_timer >= POCKET_TIMER then --TEST WiTH: 2 then --
        for _,player in ipairs(minetest.get_connected_players()) do
            local who = player:get_player_name()
            local stuff = player:get_inventory()
            spoil_meat(stuff, "main", ROT_IN_POCKET_CHANCE, true, who)
            spoil_meat(stuff, "craft", ROT_IN_POCKET_CHANCE, true, who)
        end -- for each player
        rotting_timer = 0 --reset the timer
    end -- timer
end)
end

-------------------------------------EOF----------------------------------------
