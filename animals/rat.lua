local rats_setting = minetest.settings:get("mobs.rats") or "mesh"
local USE_SPRITES = rats_setting ~= "mesh"

mobs:register_mob("rat", {
    type = "animal",

    hp_max = 10,
    armor = {crumbly = 100, cracky = 100, choppy = 100, fleshy = 100},
    walk_velocity = 3,
    run_velocity = 6,

    spawning_nodes = {"default:dirt_with_grass", "default:stone"},
    max_spawn_light = 20,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {fall = 1, water = 0, lava = 10, light = 0},

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
}, rats_setting == "disabled")

minetest.register_craftitem(":mobs:rat", {
    description = "Rat",
    inventory_image = USE_SPRITES and "mobs_rat.png" or "mobs_rat_inventory.png",

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
