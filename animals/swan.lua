local swan_setting = minetest.settings:get("mobs.swans") or "mesh"

-- <AspireMint> swan: 1-80 doing nothing ..(not finished)

mobs:register_mob("swan", {
    type = "animal",
    floats = true,

    hp_max = 12,
    armor = {crumbly = 50, cracky = 50, choppy = 100, fleshy = 100},
    walk_velocity = 1,

    spawning_nodes = {"default:water_source"},
    max_spawn_light = 20,
    min_spawn_light = -1,
    spawn_chance = 8000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {fall = 0, water = 0, lava = 1, light = 0},

    visual = "mesh",
    drawtype = "front",
    mesh = "mobs_swan.x",
    visual_size = {x=2.0, y=2.5},
    collisionbox = {-0.7, -0.01, -0.4, 0.7, 1.4, 0.4},
    textures = {"mobs_swan_mesh.png"},
    animation = {
        speed_normal = 15,
        stand_start = 1,
        stand_end = 80,
        walk_start = 1,
        walk_end = 80,
    },

    makes_footstep_sound = false,

    drops = {},
}, donkey_setting == "disabled")
