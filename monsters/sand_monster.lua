
mobs:register_mob("mobs:sand_monster", {
    type = "monster",

    hp_max = 3,
    damage = 1,
    armor = 80,
    view_range = 15,
    walk_velocity = 1.5,
    run_velocity = 4,

    water_damage = 3,
    lava_damage = 1,
    light_damage = 0,
    light_resistant = true,

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=1, y=2},
    collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
    textures = {"mobs_sand_monster.png", "mobs_sand_monster_back.png"},

    makes_footstep_sound = true,

    drops = {
        {
            name = "default:sand",
            chance = 1,
            min = 3,
            max = 5,
        },
    },
})
mobs:register_spawn("mobs:sand_monster", {"default:desert_sand"}, 20, -1, 7000, 3, 31000)
