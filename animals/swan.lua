

-- <AspireMint> swan: 1-80 doing nothing ..(not finished)

mobs:register_mob("mobs:swan", {
    type = "animal",

    hp_max = 2,
    armor = 200,
    walk_velocity = 1,

    water_damage = 0,
    lava_damage = 1,
    light_damage = 0,

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
})
