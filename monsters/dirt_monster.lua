
mobs:register_mob("mobs:dirt_monster", {
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

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=1, y=2},
    collisionbox = {-0.4, -1, -0.4, 0.4, 1, 0.4},
    textures = {"mobs_dirt_monster.png", "mobs_dirt_monster_back.png"},

    makes_footstep_sound = true,

    drops = {
        {name = "default:dirt",
        chance = 1,
        min = 3,
        max = 5,},
    },

    attack_type = "dogfight",
})
mobs:register_spawn("mobs:dirt_monster", {"default:dirt_with_grass"}, 3, -1, 7000, 3, 31000)
