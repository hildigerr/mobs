local sheep_setting = minetest.settings:get("mobs.sheep") or "mesh"
local USE_SPRITES = sheep_setting ~= "mesh"
minetest.log("info", "mobs : animals : sheep : "..sheep_setting)

mobs:register_mob("sheep", {
    type = "animal",

    hp_max = 16,
    armor = {crumbly = 25, cracky = 25, choppy = 80, fleshy = 90},
    view_range = 10,
    walk_velocity = 1,
    run_velocity = 1,

    spawning_nodes = {"default:dirt_with_grass"},
    max_spawn_light = 20,
    min_spawn_light = 8,
    spawn_chance = 9000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {water = 5, lava = 8, light = 0},

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = USE_SPRITES and "side" or "front",
    mesh = "mobs_sheep.x",
    visual_size = {x=2, y=1.25},
    collisionbox = USE_SPRITES and {-0.6, -0.625, -0.6, 0.6, 0.625, 0.6} or {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
    textures = USE_SPRITES and {"mobs_sheep.png", "mobs_sheep.png"} or {"mobs_sheep_mesh.png"},
    animation = not USE_SPRITES and {
        speed_normal = 15,
        stand_start = 0,
        stand_end = 80,
        walk_start = 81,
        walk_end = 100,
    },

    sounds = {
        random = "mobs_sheep",
    },
    makes_footstep_sound = true,
    follow = function(item)
        return item == "farming:wheat"
    end,

    drops = {
        {
            name = "mobs:meat_raw",
            chance = 1,
            min = 1,
            max = 2,
        },
    },

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "farming:wheat" then
            item:take_item()
            clicker:set_wielded_item(item)
            if not self.tamed then
                self.tamed = true
            elseif self.naked then
                self.food = (self.food or 0) + 1
                if self.food >= 8 then
                    self.food = 0
                    self.naked = false
                    self.object:set_properties({
                        textures = USE_SPRITES and {"mobs_sheep.png", "mobs_sheep.png"} or {"mobs_sheep_mesh.png"},
                        mesh = "mobs_sheep.x",
                    })
                end
            end
            return
        end
        if clicker:get_inventory() and not self.naked then
            self.naked = true
            clicker:get_inventory():add_item("main", ItemStack("wool:white "..math.random(1,2)))
            self.object:set_properties({
                textures = USE_SPRITES and {"mobs_sheep_naked.png", "mobs_sheep_naked.png"} or {"mobs_sheep_shaved.png"},
                mesh = "mobs_sheep_shaved.x",
            })
        end
    end,
}, sheep_setting == "disabled")
