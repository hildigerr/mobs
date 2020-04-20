local stone_monster_setting = minetest.settings:get("mobs.stone_monsters") or "mesh"
local USE_SPRITES = stone_monster_setting ~= "mesh"

mobs:register_mob("stone_monster", {
    type = "monster",

    hp_max = 16,
    armor = {crumbly = 1, cracky = 90, choppy = 10, fleshy = 25},
    view_range = 10,
    walk_velocity = 0.5,
    run_velocity = 2,

    spawning_nodes = {"default:stone"},
    max_spawn_light = 3,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 3,
    max_spawn_height = 0,

    damage = {water = 0, lava = 5, light = 0},
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
            chance = 2,
            min = 2,
            max = 6,
        },
    },
    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=3})
    end,
}, stone_monster_setting == "disabled")
