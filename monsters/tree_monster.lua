
mobs:register_mob("mobs:tree_monster", {
    type = "monster",

    hp_max = 5,
    damage = 2,
    armor = 80,
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,

    water_damage = 1,
    lava_damage = 5,
    light_damage = 2,
    light_resistant = true,
    disable_fall_damage = true,

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=1, y=2},
    collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
    textures = {"mobs_tree_monster.png", "mobs_tree_monster_back.png"},

    makes_footstep_sound = true,

    drops = {
        {
            name = "default:sapling",
            chance = 3,
            min = 1,
            max = 2,
        },
        {
            name = "default:junglesapling",
            chance = 3,
            min = 1,
            max = 2,
        },
    },

    attack_type = "dogfight",
})
mobs:register_spawn("mobs:tree_monster", {"default:leaves", "default:jungleleaves"}, 3, -1, 7000, 3, 31000)
