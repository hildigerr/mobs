local USE_SPRITES = minetest.settings:get_bool("mobs.use_sprites", false)

mobs:register_mob("mobs:oerkki", {
    type = "monster",

    hp_max = 8,
    damage = 4,
    armor = 60,
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,

    water_damage = 1,
    lava_damage = 1,
    light_damage = 0,
    light_resistant = true,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_oerkki.x",
    visual_size = USE_SPRITES and {x=1, y=2} or {x=5, y=5},
    collisionbox = USE_SPRITES and {-0.4, -1, -0.4, 0.4, 1, 0.4} or {-0.4, 0, -0.4, 0.4, 1.9, 0.4},
    textures = USE_SPRITES and {"mobs_oerkki.png", "mobs_oerkki_back.png"} or {"mobs_oerkki_mesh.png"},
    animation = not USE_SPRITES and {
        stand_start = 0,
        stand_end = 23,
        walk_start = 24,
        walk_end = 36,
        run_start = 37,
        run_end = 49,
        speed_normal = 15,
        speed_run = 15,
    },

    makes_footstep_sound = false,

    drops = {},
})
mobs:register_spawn("mobs:oerkki", {"default:stone"}, 2, -1, 7000, 3, -10)
