local USE_HOMEDECOR = minetest.get_modpath("homedecor")

--- SPOILING MEAT ---

local CHANCE_ROT_LITTER = tonumber(minetest.settings:get("mobs.meat_chance_rot_litter")) or 33
local CHANCE_ROT_POCKET = tonumber(minetest.settings:get("mobs.meat_chance_rot_inventory")) or 33
local CHANCE_ROT_STORAGE = tonumber(minetest.settings:get("mobs.meat_chance_rot_storage")) or 50
local CHANCE_ROT_COOKING = tonumber(minetest.settings:get("mobs.meat_chance_rot_cooking")) or 66

local GROUND_TIMER = 60 * (tonumber(minetest.settings:get("mobs.meat_timer_rot_litter")) or 3)
local POCKET_TIMER = 60 * (tonumber(minetest.settings:get("mobs.meat_timer_rot_inventory")) or 5)
local STORAGE_TIMER = 60 * (tonumber(minetest.settings:get("mobs.meat_timer_rot_storage")) or 10)
local COOKING_TIMER = 60 * (tonumber(minetest.settings:get("mobs.meat_timer_rot_cooking")) or 20)

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

if CHANCE_ROT_STORAGE > 0 then
    minetest.register_abm({
        nodenames = not USE_HOMEDECOR and {
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

if CHANCE_ROT_COOKING > 0 then
    minetest.register_abm({
        nodenames = not USE_HOMEDECOR and {"default:furnace"}
            or {"default:furnace", "homedecor:oven"},
        interval = COOKING_TIMER,
        chance = 1,
        action = function(pos, node)
            spoil_meat(minetest.get_meta(pos):get_inventory(), "src", CHANCE_ROT_COOKING)
        end
    })
end

--- Craft Items ---

minetest.register_craftitem("mobs:meat_raw", {
    description = "Raw Meat",
    inventory_image = "mobs_meat_raw.png",
    on_drop = function(itemstack, dropper, pos)
        local data = {
            timer = 0,
            quantity = itemstack:get_count(),
        }
        if dropper and dropper:is_player() then
            pos.y = pos.y + 1.2
            data.velocity = dropper:get_look_dir()
            data.velocity.x = data.velocity.x * 2.9
            data.velocity.y = data.velocity.y * 2.9 + 2
            data.velocity.z = data.velocity.z * 2.9
            local inertia = dropper:get_player_velocity()
            data.velocity.x = data.velocity.x + inertia.x
            data.velocity.y = data.velocity.y + inertia.y
            data.velocity.z = data.velocity.z + inertia.z
        end
        minetest.add_entity(pos, "mobs:meat_raw_item", minetest.serialize(data))
        itemstack:clear()
        return itemstack
    end,
    on_use = function(itemstack, user, pointed_thing)
        minetest.do_item_eat(math.random(-4,2), nil, itemstack, user, pointed_thing)
    end,
    groups = { eatable=1, meat=1 },
})

minetest.register_entity("mobs:meat_raw_item", {
    physical = true,
    visual = "item",
    wield_item = "mobs:meat_raw",
    visual_size = {x=0.25, y=0.25},
    collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
    automatic_rotate = math.pi/2,
    staticdata = {
        timer = 0,
        quantity = 1,
    },

    get_staticdata = function(self)
        return minetest.serialize(self.staticdata)
    end,

    on_activate = function(self, staticdata, dtime_s)
        self.object:set_armor_groups({punch_operable=1})
        if staticdata then
            self.staticdata = minetest.deserialize(staticdata)
        end
        if self.quantity == 0 then
            self.object:remove()
            return
        end
        if self.staticdata.velocity then
            self.object:set_velocity(self.staticdata.velocity)
        end
        self.object:set_acceleration({x=0, y=-10, z=0})
        self:on_step(dtime_s)
    end,

    on_step = CHANCE_ROT_LITTER > 0 and
        function(self, dtime)
            if self.object:get_velocity().y == 0 then
                self.object:set_velocity({x=0, y=0, z=0})
            end
            self.staticdata.timer = self.staticdata.timer+dtime
            if self.staticdata.timer > GROUND_TIMER then
                if math.random(1, 100) <= CHANCE_ROT_LITTER then
                    pos = self.object:get_pos()
                    quantity_string = tostring(self.staticdata.quantity)
                    if minetest.add_item(pos, "mobs:meat_rotten "..quantity_string) then
                        mobs.barf("info", "meat", "rotted", minetest.pos_to_string(pos), quantity_string)
                        self.object:remove()
                        return
                    end
                end
                self.staticdata.timer = self.staticdata.timer+dtime
            end
        end,

    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
        if puncher and puncher:is_player() and puncher:get_inventory() then
            stack = ItemStack("mobs:meat_raw "..tostring(self.staticdata.quantity))
            leftovers = puncher:get_inventory():add_item("main", stack)
            mobs.barf("mobs:meat_raw", tostring(self.staticdata.quantity), "remainder", tostring(leftovers:get_count()))
            self.staticdata.quantity = leftovers:get_count()
            if self.staticdata.quantity == 0 then
                self.object:remove()
            end
        end
    end,

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "mobs:meat_raw" then
            item:take_item()
            clicker:set_wielded_item(item)
            self.staticdata.quantity = self.staticdata.quantity+1
        end
    end,
})

minetest.register_craftitem("mobs:meat", {
    description = "Meat",
    inventory_image = "mobs_meat.png",
    on_use = minetest.item_eat(4),
    groups = { eatable=2, meat=1 },
})

minetest.register_craftitem("mobs:meat_rotten", {
    description = "Rotten Meat",
    image = "mobs_meat_rotten.png",
    on_use = minetest.item_eat(-4),
    groups = { eatable=1 },
})

minetest.register_craftitem("mobs:scorched_stuff", {
    description = "Scorched stuff",
    inventory_image = "mobs_scorched_stuff.png",
})

--- Cooking Crafts ---

minetest.register_craft({
    type = "cooking",
    output = "mobs:meat",
    recipe = "mobs:meat_raw",
    cooktime = 5,
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:scorched_stuff",
    recipe = "mobs:meat",
    cooktime = 2,
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:scorched_stuff",
    recipe = "mobs:meat_rotten",
    cooktime = 3,
})

--- Dye Crafts --

minetest.register_craft({
   type = "shapeless",
   output = 'dye:grey 1',
   recipe = {
        "mobs:scorched_stuff",
    }
})

minetest.register_craft({
   type = "shapeless",
   output = 'dye:black 1',
   recipe = {
        "mobs:scorched_stuff",
        "dye:grey",
    }
})
