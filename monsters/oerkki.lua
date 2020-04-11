
mobs:register_mob("mobs:oerkki", {
    type = "monster",
    hp_max = 8,
    collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
    visual = "upright_sprite",
    visual_size = {x=1, y=2},
    textures = {"mobs_oerkki.png", "mobs_oerkki_back.png"},
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
})
mobs:register_spawn("mobs:oerkki", {"default:stone"}, 2, -1, 7000, 3, -10)
