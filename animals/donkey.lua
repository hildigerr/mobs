local donkey_setting = minetest.settings:get("mobs.donkeys") or "mesh"

mobs:register_mob("donkey", {
    type = "animal",

    hp_max = 15,
    armor = {crumbly = 25, cracky = 25, choppy = 80, fleshy = 90},
    walk_velocity = 1,

    spawning_nodes = {"default:dirt_with_grass", "default:stone"},
    max_spawn_light = 20,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {water = 5, lava = 8, light = 0},

    visual = "mesh",
    drawtype = "backside",
    mesh = "mobs_donkey.x",
    visual_size = {x=2.0, y=2.5},
    collisionbox = {-0.7, -0.01, -0.4, 0.7, 1.4, 0.4},
    textures = {"mobs_donkey_mesh.png"},
    animation = {
        speed_normal = 15,
        stand_start = 1,
        stand_end = 40,
        walk_start = 40,
        walk_end = 60,
        run_start = 45,
        run_end = 85,
    },

-- frames:
--     1-40 standing (without backpack), 45-85 running (without backpack),
--     90-130 standing (empty backpack), 135-175 running (empty backpack),
--     180-220 standing (full backpack), 225-265 running (full backpack)

    makes_footstep_sound = false,

    drops = {},

    static_default = { bag = nil },

    after_activate = function(self, dtime_s)
        if self.static.bag then
            if self.static.bag == "empty" then
                self.animation = {
                    speed_normal = 15,
                    stand_start = 90,
                    stand_end = 130,
                    walk_start = 135,
                    walk_end = 175,
                }
            elseif self.static.bag == "full" then
                self.animation = {
                    speed_normal = 15,
                    stand_start = 180,
                    stand_end = 220,
                    walk_start = 225,
                    walk_end = 265,
                }
            end
        end
    end,
}, donkey_setting == "disabled")
