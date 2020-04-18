----Cow:
mobs:register_mob("cow", {
    type = "animal",

    hp_max = 8,
    armor = 90,
    view_range = 10,
    walk_velocity = 1,
    run_velocity = 2,

    spawning_nodes = {"default:dirt_with_grass"},
    max_spawn_light = 20,
    min_spawn_light = 8,
    spawn_chance = 6000,
    max_spawn_count = 2,
    max_spawn_height = 31000,

    damage = {water = 1, lava = 8, light = 0},

    visual = "upright_sprite",
    drawtype = "side",
    visual_size = {x=2.375, y=3.125},
    collisionbox = {-0.8, -1, -0.8, 0.9, 0.55, 0.9},
    textures = { "mobs_cow.png", "mobs_cow.png"},

    sounds = {
        random = "mobs_cow",
    },
    makes_foostep_sound = true,
    follow = function(item)
        return string.find(item, "grass") and not string.find(item, "seed")
    end,

    drops = {
        {
            name = "mobs:meat_raw",
           chance = 1,
          min = 2,
          max = 4,
        },
    },

    on_rightclick = function(self, clicker)
        tool = clicker:get_wielded_item():get_name()
        if tool == "bucket:bucket_empty" then
            if self.milked then
                minetest.sound_play("mobs_cow_mad", {
                    object = self.object,
                    gain = 1.0, -- default
                    max_hear_distance = 32, -- default
                    loop = false,
                })
                do return end
            else
                minetest.sound_play("mobs_milk_splash", {
                    to_player = clicker:get_player_name(),
--                    object = self.object,
                    gain = 1.0, -- default
--                    max_hear_distance = 32, -- default
--                    loop = false,
                })
            end
            clicker:get_inventory():remove_item("main", "bucket:bucket_empty")
            clicker:get_inventory():add_item("main", "mobs:milk_bucket")
            if math.random(1,2) > 1 then self.milked = true    end
        elseif tool == "vessels:glass_bottle" then
            if self.milked then
                minetest.sound_play("mobs_cow_mad", {
                    object = self.object,
                    gain = 1.0, -- default
                    max_hear_distance = 32, -- default
                    loop = false,
                })
                do return end
            else
                minetest.sound_play("mobs_milk_splash", {
                    to_player = clicker:get_player_name(),
--                    object = self.object,
                    gain = 1.0, -- default
--                    max_hear_distance = 32, -- default
--                    loop = false,
                })
            end
            clicker:get_inventory():remove_item("main", "vessels:glass_bottle")
            clicker:get_inventory():add_item("main", "mobs:milk_bottle_glass")
            if math.random(1,3) > 2 then self.milked = true    end
        elseif tool == "vessels:drinking_glass" then
            if self.milked then
                minetest.sound_play("mobs_cow_mad", {
                    object = self.object,
                    gain = 1.0, -- default
                    max_hear_distance = 32, -- default
                    loop = false,
                })
                do return end
            else
                minetest.sound_play("mobs_milk_splash", {
                    to_player = clicker:get_player_name(),
--                    object = self.object,
                    gain = 1.0, -- default
--                    max_hear_distance = 32, -- default
--                    loop = false,
                })
            end
            clicker:get_inventory():remove_item("main", "vessles:drinking_glass")
            clicker:get_inventory():add_item("main", "mobs:milk_glass_cup")
            if math.random(1,4) > 3 then self.milked = true    end
        elseif tool == "vessels:steel_bottle" then
            if self.milked then
                minetest.sound_play("mobs_cow_mad", {
                    object = self.object,
                    gain = 1.0, -- default
                    max_hear_distance = 32, -- default
                    loop = false,
                })
                do return end
            else
                minetest.sound_play("mobs_milk_splash", {
                    to_player = clicker:get_player_name(),
--                    object = self.object,
                    gain = 1.0, -- default
--                    max_hear_distance = 32, -- default
--                    loop = false,
                })
            end
            clicker:get_inventory():remove_item("main", "vessels:steel_bottle")
            clicker:get_inventory():add_item("main", "mobs:milk_bottle_steel")
            if math.random(1,3) > 2 then self.milked = true end
        end -- tool ifs
    end, -- on_rightclick func
})

minetest.register_craftitem(":mobs:milk_bucket", {
    description = "Bucket of Milk",
    image = "mobs_bucket_milk.png",
    on_use = minetest.item_eat(8,"bucket:bucket_empty"),
    groups = { eatable=1 },
    stack_max = 1,
})

minetest.register_craftitem(":mobs:milk_bottle_glass", {
    description = "Bottle of Milk",
    image = "mobs_glass_bottle_milk.png",
    wield_image = "mobs_glass_bottle_milk_wield.png",
    on_use = minetest.item_eat(4, "vessels:glass_bottle"),
    groups = { eatable=1 },
})

minetest.register_craftitem(":mobs:milk_glass_cup", {
    description = "Bottle of Milk",
    image = "mobs_drinking_glass_milk.png",
    wield_image = "mobs_drinking_glass_milk_wield.png",
    on_use = minetest.item_eat(2, "vessels:drinking_glass"),
    groups = { eatable=1 },
})

minetest.register_craftitem(":mobs:milk_bottle_steel", {
    description = "Flask of Milk",
    image = --"vessels_steel_bottle.png",
        "mobs_steel_bottle_milk.png",
    on_use = minetest.item_eat(4, "vessels:steel_bottle"),
    groups = { eatable=1 },
})
