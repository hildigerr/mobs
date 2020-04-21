
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

    on_step = minetest.settings:get_bool("mobs.meat_rots", true) and
    function(self, dtime)
        if self.object:get_velocity().y == 0 then
            self.object:set_velocity({x=0, y=0, z=0})
        end
        self.staticdata.timer = self.staticdata.timer+dtime
        if self.staticdata.timer > 360 then -- GROUND_TIMER
            if math.random(1, 100) <= 33 then -- ROT_ON_GROUND_CHANCE
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
