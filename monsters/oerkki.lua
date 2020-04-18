local oerkki_setting = minetest.settings:get("mobs.oerkki") or "mesh"
local USE_SPRITES = oerkki_setting ~= "mesh"

mobs:register_mob("oerkki", {
    type = "monster",

    hp_max = 8,
    armor = {fleshy = 60},
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,

    spawning_nodes = {"default:stone"},
    max_spawn_light = 2,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 3,
    max_spawn_height = -10,

    damage = {water = 1, lava = 1, light = 0},
    light_resistant = true,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_oerkki.x",
    visual_size = USE_SPRITES and {x=1, y=2} or {x=5, y=5},
    collisionbox = USE_SPRITES and {-0.4, -1, -0.4, 0.4, 1, 0.4} or {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
    textures = USE_SPRITES and {"mobs_oerkki.png", "mobs_oerkki_back.png"} or {"mobs_oerkki_mesh.png"},
    animation = not USE_SPRITES and {
        stand_start = 0,
        stand_end = 23,
        walk_start = 24,
        walk_end = 36,
        run_start = 37,
        run_end = 49,
        punch_start = 37,
        punch_end = 49,
        speed_normal = 15,
        speed_run = 15,
    },

    makes_footstep_sound = false,

    drops = {},

    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=4})
    end,
}, oerkki_setting == "disabled")
