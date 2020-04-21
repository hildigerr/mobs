local racoon_setting = minetest.settings:get("mobs.racoons") or "sprite"
minetest.log("info", "mobs : animals : racoons : "..racoon_setting)

mobs:register_mob("racoon", {
    type = "animal",

    hp_max = 14,
    armor = {crumbly = 25, cracky = 25, choppy = 70, fleshy = 80},
    view_range = 15,
    walk_velocity = 2,
    run_velocity = 2,

    spawning_nodes = {"default:dirt_with_grass"},
    max_spawn_light = 20,
    min_spawn_light = 8,
    spawn_chance = 8000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {fall = 1, water = 3, lava = 5, light = 0},

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=0.7, y=0.7},
    collisionbox = {-0.25, -0.33, -0.25, 0.25, 0.33, 0.25},
    textures = {"mobs_racoon.png", "mobs_racoon.png"},

    makes_footstep_sound = false,

    drops = {
        {
            name = "default:apple",
            chance = 4,
            min = 1,
            max = 1,
        },
    },

    static_default = {
        stolen = {},
        aggrivated = false,
    },

    after_activate = function(self, dtime_s)
        if self.static.aggrivated then
            self.type = "monster"
            self.attack = function(self, target)
                return mobs:slap(self, target.player, {fleshy=2})
            end
            for _,item_name in ipairs(self.static.stolen) do
                table.insert(self.drops, {
                    name = item_name,
                    chance = 1, min = 1, max = 1
                })
            end
        end
        mobs.barf("info", "racoon", "is a "..self.type, minetest.pos_to_string(self.object:get_pos()), "testing" )
    end,

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        local item_name = item:get_name()
        local aggrivate = minetest.get_item_group(item_name, "eatable") == 0
        item:take_item()
        clicker:set_wielded_item(item)
        if aggrivate then
            self.static.aggrivated = true
            table.insert(self.static.stolen, item_name)
            table.insert(self.drops, {
                name = item_name,
                chance = 1, min = 1, max = 1
            })
            if self.type == "animal" then
                self.type = "monster"
                self.attack = function(self, target)
                    return mobs:slap(self, target.player, {fleshy=2})
                end
            end
        end
    end,
}, racoon_setting == "disabled")
