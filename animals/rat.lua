
mobs:register_mob("mobs:rat", {
    type = "animal",
    hp_max = 1,
    collisionbox = {-0.25, -0.175, -0.25, 0.25, 0.33, 0.25},
    visual = "upright_sprite",
    visual_size = {x=0.7, y=0.35},
    textures = {"mobs_rat.png", "mobs_rat.png"},
    makes_footstep_sound = false,
    walk_velocity = 1,
    run_velocity = 2,
    armor = 100,
    drops = {},
    drawtype = "front",
    water_damage = 0,
    lava_damage = 1,
    light_damage = 0,

    on_rightclick = function(self, clicker)
        if clicker:is_player() and clicker:get_inventory() then
            clicker:get_inventory():add_item("main", "mobs:rat")
            self.object:remove()
        end
    end,
})
mobs:register_spawn("mobs:rat", {"default:dirt_with_grass", "default:stone"}, 20, -1, 7000, 1, 31000)

minetest.register_craftitem("mobs:rat", {
    description = "Rat",
    inventory_image = "mobs_rat.png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
            minetest.env:add_entity(pointed_thing.above, "mobs:rat")
            itemstack:take_item()
        end
        return itemstack
    end,
})

minetest.register_craftitem("mobs:rat_cooked", {
    description = "Cooked Rat",
    inventory_image = "mobs_cooked_rat.png",
    on_use = minetest.item_eat(3),
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:rat_cooked",
    recipe = "mobs:rat",
    cooktime = 5,
})
