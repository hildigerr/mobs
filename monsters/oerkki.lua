
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

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=1, y=2},
    collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
    textures = {"mobs_oerkki.png", "mobs_oerkki_back.png"},

    makes_footstep_sound = false,

    drops = {},

    attack_type = "dogfight",
})
mobs:register_spawn("mobs:oerkki", {"default:stone"}, 2, -1, 7000, 3, -10)
