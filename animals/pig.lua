
mobs:register_mob("mobs:pig", {
    type = "animal",

    hp_max = 5,
    armor = 200,
    view_range = 5,
    walk_velocity = 1,

    water_damage = 1,
    lava_damage = 5,
    light_damage = 0,

    visual = "mesh",
    drawtype = "front",
    mesh = "mobs_pig.x",
    textures = {"mobs_pig.png"},
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

})
