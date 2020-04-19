
mobs:register_mob("cow", {
    type = "animal",

    hp_max = 18,
    armor = {crumbly = 15, cracky = 25, choppy = 80, fleshy = 90},
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
        local item = clicker:get_wielded_item()
        local tool = item:get_name()
        local drop = 
            (tool == "bucket:bucket_empty"    and "mobs:milk_bucket")       or
            (tool == "vessels:glass_bottle"   and "mobs:milk_bottle_glass") or
            (tool == "vessels:drinking_glass" and "mobs:milk_glass_cup")    or
            (tool == "vessels:steel_bottle"   and "mobs:milk_bottle_steel")
        if drop then
            if self.dry then
                minetest.sound_play("mobs_cow_mad", {object = self.object})
            else
                minetest.sound_play("mobs_milk_splash", {
                    to_player = clicker:get_player_name(),
                })
                clicker:get_inventory():remove_item("main", tool)
                clicker:get_inventory():add_item("main", drop)
                if math.random(1,100) <= 50 then self.dry = true end
            end
        end
    end
})
