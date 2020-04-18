local USE_SPRITES = minetest.settings:get_bool("mobs.use_sprites", false)

mobs:register_mob("rat", {
    type = "animal",

    hp_max = 1,
    armor = 100,
    walk_velocity = 1,
    run_velocity = 2,

    spawning_nodes = {"default:dirt_with_grass", "default:stone"},
    max_spawn_light = 20,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    water_damage = 0,
    lava_damage = 1,
    light_damage = 0,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_rat.x",
    visual_size = {x=0.7, y=0.35},
    collisionbox = USE_SPRITES and {-0.25, -0.175, -0.25, 0.25, 0.33, 0.25} or {-0.2, -0.01, -0.2, 0.2, 0.2, 0.2},
    textures = USE_SPRITES and {"mobs_rat.png", "mobs_rat.png"} or {"mobs_rat_mesh.png"},

    makes_footstep_sound = false,

    drops = {},

    on_rightclick = function(self, clicker)
        if clicker:is_player() and clicker:get_inventory() then
            clicker:get_inventory():add_item("main", "mobs:rat")
            self.object:remove()
        end
    end,
})

minetest.register_craftitem(":mobs:rat", {
    description = "Rat",
    inventory_image = "mobs_rat.png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
            minetest.add_entity(pointed_thing.above, "mobs:rat")
            itemstack:take_item()
        end
        return itemstack
    end,
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:meat",
    recipe = "mobs:rat",
    cooktime = 5,
})
