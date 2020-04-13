
mobs:register_mob("mobs:stone_monster", {
    type = "monster",

    hp_max = 10,
    damage = 3,
    armor = 70,
    view_range = 10,
    walk_velocity = 0.5,
    run_velocity = 2,

    water_damage = 0,
    lava_damage = 0,
    light_damage = 0,
    light_resistant = true,

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=1, y=2},
    collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
    textures = {"mobs_stone_monster.png", "mobs_stone_monster_back.png"},

    makes_footstep_sound = true,

    drops = {
        {
            name = "default:mossycobble",
            chance = 1,
            min = 3,
            max = 5,
        },
    },

    attack_type = "dogfight",
})
mobs:register_spawn("mobs:stone_monster", {"default:stone"}, 3, -1, 7000, 3, 0)
