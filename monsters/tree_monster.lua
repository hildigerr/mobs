local USE_SPRITES = minetest.settings:get_bool("mobs.use_sprites", false)

mobs:register_mob("mobs:tree_monster", {
    type = "monster",

    hp_max = 5,
    armor = 80,
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,

    water_damage = 1,
    lava_damage = 5,
    light_damage = 2,
    light_resistant = true,
    disable_fall_damage = true,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_tree_monster.x",
    visual_size = USE_SPRITES and {x=1, y=2} or {x=4.5,y=4.5},
    collisionbox = USE_SPRITES and {-0.4, -1, -0.4, 0.4, 0.9, 0.4} or {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
    textures = USE_SPRITES and {"mobs_tree_monster.png", "mobs_tree_monster_back.png"} or {"mobs_tree_monster_mesh.png"},
    animation = not USE_SPRITES and {
        speed_normal = 15,
        speed_run = 15,
        stand_start = 0,
        stand_end = 24,
        walk_start = 25,
        walk_end = 47,
        run_start = 48,
        run_end = 62,
        punch_start = 48,
        punch_end = 62,
    },

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
    attack_method = function(self, target)
        mobs:slap(self, target.player, {fleshy=2})
    end,
})
mobs:register_spawn("mobs:tree_monster", {"default:leaves", "default:jungleleaves"}, 3, -1, 7000, 3, 31000)
