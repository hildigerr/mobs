
--turtle: 1-50 doing nothing, 60-90 running, 95-100 hidden, 105-135 swimming

mobs:register_mob("mobs:turtle", {
    type = "animal",

    hp_max = 2,
    armor = 200,
    walk_velocity = 1,

    water_damage = 0,
    lava_damage = 1,
    light_damage = 0,

    visual = "mesh",
    drawtype = "front",
    mesh = "mobs_turtle.x",
    visual_size = {x=1.5, y=1.5},
    collisionbox = {-0.7, -0.01, -0.4, 0.7, 1.4, 0.4},
    textures = {"mobs_turtle.png"},
    animation = {
        speed_normal = 5,
        stand_start = 1,
        stand_end = 50,
        walk_start = 60,
        walk_end = 90,
        punch_start = 95,
        punch_end = 100,
    },

    makes_footstep_sound = false,

    drops = {},

})

mobs:register_mob("mobs:turtle_hidden", {
    type = "animal",

    hp_max = 2,
    armor = 200,
    walk_velocity = 1,

    water_damage = 0,
    lava_damage = 1,
    light_damage = 0,

    visual = "mesh",
    drawtype = "front",
    mesh = "mobs_turtle.x",
    visual_size = {x=1.0, y=1.0},
    collisionbox = {-0.7, -0.01, -0.4, 0.7, 1.4, 0.4},
    textures = {"mobs_turtle.png"},
    animation = {
        speed_normal = 0,
        stand_start = 95,
        stand_end = 100,
        walk_start = 60,
        walk_end = 90,
    },

    makes_footstep_sound = false,

    drops = {},

})

