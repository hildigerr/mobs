local rabbit_setting = minetest.settings:get("mobs.rabbits") or "mesh"
local USE_SPRITES = rabbit_setting ~= "mesh"
minetest.log("info", "mobs : animals : rabbits : "..rabbit_setting)

local rabbit_colors = { "white", "grey", "brown", "black" }

for i,v in ipairs( rabbit_colors ) do
mobs:register_mob("rabbit_"..v, {
    type = "animal",

    hp_max = 12,
    armor = {crumbly = 25, cracky = 25, choppy = 90, fleshy = 100},
    view_range = 15,
    attack_range = 12,
    walk_velocity = 4,
    run_velocity = 1,

    spawning_nodes = {"default:dirt_with_grass"},
    max_spawn_light = 20,
    min_spawn_light = 8,
    spawn_chance = 8000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {water = 4, lava = 12, light = 0},

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = USE_SPRITES and "front" or "side",
    mesh = "mobs_rabbit.x",
    visual_size = USE_SPRITES and {x=0.7, y=0.7} or {x=0.5, y=0.5},
    collisionbox = USE_SPRITES and {-0.25, -0.33, -0.25, 0.25, 0.33, 0.25} or {-0.2, -0.01, -0.2, 0.2, 0.4, 0.2},
    textures = USE_SPRITES and {"mobs_rabbit_"..v..".png", "mobs_rabbit_"..v..".png"} or {"mobs_rabbit_"..v.."_mesh.png"},
    animation = {
        speed_normal = 15,
        stand_start = 0,
        stand_end = 30,
        walk_start = 40,
        walk_end = 60,
    },

    makes_footstep_sound = false,
    follow = function(item)
        return item == "mobs:carrot"
            or minetest.get_item_group(item, "food_berry") ~= 0
    end,

    attack = function(self, target)
        if self.tamed then
            self.run_velocity = 2
            self.walk_velocity = 2
            self.view_range = 10
            self.attack_range = 2
            self.attack = function(self, target)
                if self.timer > 10 and math.random(1, 100) <= 15 then
                    self.timer = 0
                    minetest.chat_send_player(
                        target.player:get_player_name(),
                        "[Rabbit] May I have your "..
                            string.match(target.player:get_wielded_item():get_name(), ":(%a+)")..
                            " please?"
                    )
                end
                return false
            end
            self.timer = 0
            return true
        elseif self.timer > 1 then
            chance = math.random(1, 100)
            if chance <= 10 then
                self.state = "flee"
                self.follow = false
                self.run_velocity = self.walk_velocity
                self.object:set_yaw(self.object:get_yaw()+(math.pi/4)*math.random(2,5))
                self:try_jump()
                self.set_velocity(self, self.run_velocity)
                self.set_animation(self, "run")
            elseif chance <= 45 then
                if self.attack_range > 2 then
                    self.attack_range = self.attack_range-1
                end
            end
            self.timer = 0
        end
        return false
    end,

    drops = {
        {
            name = "mobs:carrot",
            chance = 4,
            min = 1,
            max = 1,
        },
        {
            name = "wool:"..v,
            chance = 60,
            min = 1,
            max = 1,
        }
    },

    on_rightclick = function(self, clicker)
        local item = clicker:get_wielded_item()
        if item:get_name() == "mobs:carrot" then
            item:take_item()
            clicker:set_wielded_item(item)
            self.tamed = true
            if self.state == "flee" then
                self.state = "stand"
            end
        elseif clicker:is_player() and clicker:get_inventory() then
            clicker:get_inventory():add_item("main", "mobs:rabbit_"..v)
            self.object:remove()
        end
    end,
}, rabbit_setting == "disabled")

minetest.register_craftitem(":mobs:rabbit_"..v, {
    description = "Rabbit ("..v..")",
    inventory_image = "mobs_rabbit_"..v..".png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
            minetest.add_entity(pointed_thing.above, "mobs:rabbit_"..v)
            itemstack:take_item()
        end
        return itemstack
    end,
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:meat",
    recipe = "mobs:rabbit_"..v,
})
end
