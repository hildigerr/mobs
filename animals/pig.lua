local pig_setting = minetest.settings:get("mobs.pigs") or "mesh"

mobs:register_mob("pig", {
    type = "animal",

    hp_max = 15,
    armor = {crumbly = 25, cracky = 25, choppy = 80, fleshy = 90},
    view_range = 5,
    walk_velocity = 1,

    damage = {fall = 2, water = 5, lava = 8, light = 0},

    visual = "mesh",
    drawtype = "front",
    mesh = "mobs_pig.x",
    textures = {"mobs_pig_mesh.png"},
    collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
    animation = {
        speed_normal = 15,
        stand_start = 0,
        stand_end = 80,
        walk_start = 81,
        walk_end = 100,
    },

    sounds = {
        "mobs_pig",
    },
    makes_footstep_sound = true,

    drops = {
        {
            name = "mobs:meat_raw",
            chance = 1,
            min = 2,
            max = 3,
        },
    },

}, pig_setting == "disabled")
