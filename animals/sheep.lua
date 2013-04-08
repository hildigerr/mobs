local USE_SPRITES = minetest.settings:get_bool("mobs.use_sprites", false)

mobs:register_mob("mobs:sheep", {
    type = "animal",

    hp_max = 5,
    armor = 90,
    view_range = 10,
    walk_velocity = 1,
    run_velocity = 1,

    water_damage = 1,
    lava_damage = 5,
    light_damage = 0,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = USE_SPRITES and "side" or "front",
    mesh = "mobs_sheep.x",
    visual_size = {x=2, y=1.25},
    collisionbox = USE_SPRITES and {-0.6, -0.625, -0.6, 0.6, 0.625, 0.6} or {-0.4, 0, -0.4, 0.4, 1, 0.4},
    textures = USE_SPRITES and {"mobs_sheep.png", "mobs_sheep.png"} or {"mobs_sheep_mesh.png"},
    animation = not USE_SPRITES and {
        speed_normal = 10,
        stand_start = 0,
        stand_end = 59,
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
            min = 2,
            max = 3,
        },
    },

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "farming:wheat" then
            if not self.tamed then
                if not minetest.settings:get_bool("creative_mode", false) then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
                self.tamed = true
            elseif self.naked then
                if not minetest.settings:get_bool("creative_mode", false) then
                    item:take_item()
                    clicker:set_wielded_item(item)
                end
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
            if minetest.registered_items["wool:white"] then
                clicker:get_inventory():add_item("main", ItemStack("wool:white "..math.random(1,3)))
            end
            self.object:set_properties({
                textures = USE_SPRITES and {"mobs_sheep_naked.png", "mobs_sheep_naked.png"} or {"mobs_sheep_shaved.png"},
                mesh = "mobs_sheep_shaved.x",
            })
        end
    end,
})
mobs:register_spawn("mobs:sheep", {"default:dirt_with_grass"}, 20, 8, 9000, 1, 31000)
