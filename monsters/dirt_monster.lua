local USE_SPRITES = minetest.settings:get_bool("mobs.use_sprites", false)

mobs:register_mob(":mobs:dirt_monster", {
    type = "monster",

    hp_max = 5,
    armor = 80,
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,

    water_damage = 1,
    lava_damage = 5,
    light_damage = 2,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_stone_monster.x",
    visual_size = USE_SPRITES and {x=1, y=2} or {x=3, y=2.6},
    collisionbox = USE_SPRITES and {-0.4, -1, -0.4, 0.4, 0.9, 0.4} or {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
    textures = USE_SPRITES and {"mobs_dirt_monster.png", "mobs_dirt_monster_back.png"} or {"mobs_dirt_monster_mesh.png"},
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
        {name = "default:dirt",
        chance = 1,
        min = 3,
        max = 5,},
    },
    
    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=2})
    end,
})
mobs:register_spawn("mobs:dirt_monster", {"default:dirt_with_grass"}, 3, -1, 7000, 3, 31000)
