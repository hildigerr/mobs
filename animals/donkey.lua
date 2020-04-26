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
        if self.tamed then
            if self.static.owner then
                self.object:set_nametag_attributes({text = self.static.owner.."'s donkey"})
            end
            self.animation = not self.static.bag and
                 {
                    speed_normal = 15,
                    stand_start = 90,
                    stand_end = 130,
                    walk_start = 135,
                    walk_end = 175,
                }
            or
                {
                    speed_normal = 15,
                    stand_start = 180,
                    stand_end = 220,
                    walk_start = 225,
                    walk_end = 265,
                }
        end
    end,

    on_rightclick = function(self, clicker)
        local open_donkey_chest = function(self, clicker)
            minetest.sound_play("default_chest_open", {gain = 0.3,
            pos = self.object:get_pos(), max_hear_distance = 10}, true)
        end
        local item = clicker:get_wielded_item()
        local item_name = item:get_name()
        if item_name == "mobs:carrot" or item_name == "default:apple" then
            item:take_item()
            self.static.stubbornness = (self.static.stubbornness or math.random(8,20)) - 1
            if self.static.stubbornness <= 0 then
                self.tamed = true
            end
        elseif self.tamed then
            if self.static.owner then
                if self.static.owner == clicker:get_player_name() then
                    open_donkey_chest(self, clicker)
                    return
                end
            else
                if not self.static.bag then
                    if item_name == "default:chest_locked" then
                        item:take_item()
                        self.static.owner = clicker:get_player_name()
                        self.static.bag = {}
                    elseif item_name == "default:chest" then
                        item:take_item()
                        self.static.bag = {}
                    end
                else
                    if item_name == "default:chest_locked" and not next(self.static.bag) then
                        item:take_item()
                        clicker:set_wielded_item(item)
                        self.static.owner = clicker:get_player_name()
                        item = ItemStack("default:chest")
                    else
                        open_donkey_chest(self, clicker)
                        return
                    end
                end
            end
        end
        clicker:set_wielded_item(item)
        self.after_activate(self, 0)
    end,
}, donkey_setting == "disabled")
