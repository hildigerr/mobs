local dirt_monster_setting = minetest.settings:get("mobs.dirt_monsters") or "mesh"
local USE_SPRITES = dirt_monster_setting ~= "mesh"
minetest.log("info", "mobs : monsters : dirt monster : "..dirt_monster_setting)

mobs:register_mob("dirt_monster", {
    type = "monster",

    hp_max = 14,
    armor = {crumbly = 85, cracky = 50, choppy = 40, fleshy = 50},
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,

    spawning_nodes = {"default:dirt_with_grass"},
    max_spawn_light = 3,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 3,
    max_spawn_height = 31000,

    damage = {water = 14, lava = 5, light = 3},

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
        {
            name = "default:dirt",
            chance = 2,
            min = 1,
            max = 4,
        },
    },

    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=2})
    end,
}, dirt_monster_setting == "disabled")
