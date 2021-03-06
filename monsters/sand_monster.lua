local sand_monster_setting = minetest.settings:get("mobs.sand_monsters") or "mesh"
local USE_SPRITES = sand_monster_setting ~= "mesh"
minetest.log("info", "mobs : monsters : sand monster : "..sand_monster_setting)

mobs:register_mob("sand_monster", {
    type = "monster",

    hp_max = 14,
    armor = {crumbly = 90, cracky = 30, choppy = 10, fleshy = 25},
    view_range = 15,
    walk_velocity = 1.5,
    run_velocity = 4,

    spawning_nodes = {"default:desert_sand"},
    max_spawn_light = 20,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 3,
    max_spawn_height = 31000,

    damage = {fall = 3, water = 14, lava = 14, light = 0},
    light_resistant = true,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_sand_monster.x",
    visual_size = USE_SPRITES and {x=1, y=2} or {x=8,y=8},
    collisionbox = USE_SPRITES and {-0.4, -1, -0.4, 0.4, 0.9, 0.4} or {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
    textures = USE_SPRITES and {"mobs_sand_monster.png", "mobs_sand_monster_back.png"} or {"mobs_sand_monster_mesh.png"},
    animation = not USE_SPRITES and {
        speed_normal = 15,
        speed_run = 15,
        stand_start = 0,
        stand_end = 39,
        walk_start = 41,
        walk_end = 72,
        run_start = 74,
        run_end = 105,
        punch_start = 74,
        punch_end = 105,
    },

    makes_footstep_sound = true,

    drops = {
        {
            name = "default:sand",
            chance = 2,
            min = 1,
            max = 2,
        },
    },

    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=1})
    end,
}, sand_monster_setting == "disabled")
