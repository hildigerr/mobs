-------------------
-------------------
------Dragon-------
-------------------
-------------------
mobs:register_mob("mobs:dragon", {
    type = "monster",
    hp_max = 8,
    collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
    visual = "mesh",
    mesh = "mobs_dragon.x",
    textures = {"mobs_dragon.png"},
    visual_size = {x=5, y=5},
    makes_footstep_sound = false,
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,
    damage = 4,
    drops = {},
    armor = 100,
    drawtype = "front",
    light_resistant = true,
    water_damage = 1,
    lava_damage = 1,
    light_damage = 0,
    attack_type = "dogfight",
    animation = {
        stand_start = 0,
        stand_end = 40,
        walk_start = 41,
        walk_end = 61,
        run_start = 62,
        run_end = 103,
        punch_start = 104,
        punch_end = 113,
        speed_normal = 62,
        speed_run = 103,
    },
})
