local USE_SPRITES = minetest.settings:get_bool("mobs.use_sprites", false)

mobs:register_mob(":mobs:stone_monster", {
    type = "monster",

    hp_max = 10,
    armor = 70,
    view_range = 10,
    walk_velocity = 0.5,
    run_velocity = 2,

    water_damage = 0,
    lava_damage = 0,
    light_damage = 0,
    light_resistant = true,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_stone_monster.x",
    visual_size = USE_SPRITES and {x=1, y=2} or {x=3, y=2.6},
    collisionbox = USE_SPRITES and {-0.4, -1, -0.4, 0.4, 1, 0.4} or {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
    textures = USE_SPRITES and {"mobs_stone_monster.png", "mobs_stone_monster_back.png"} or {"mobs_stone_monster_mesh.png"},
    animation = not USE_SPRITES and {
        speed_normal = 15,
        speed_run = 15,
        stand_start = 0,
        stand_end = 14,
        walk_start = 15,
        walk_end = 38,
        run_start = 40,
        run_end = 63,
        punch_start = 40,
        punch_end = 63,
    },

    makes_footstep_sound = true,

    drops = {
        {
            name = "default:mossycobble",
            chance = 1,
            min = 3,
            max = 5,
        },
    },
    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=3})
    end,
})
mobs:register_spawn("mobs:stone_monster", {"default:stone"}, 3, -1, 7000, 3, 0)
