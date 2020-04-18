----Rabbit:
if minetest.get_modpath("food") ~= nil then
    minetest.register_alias("mobs:carrot", "food:carrot")
elseif minetest.get_modpath("farming_plus") ~= nil then
    minetest.register_alias("mobs:carrot", "farming_plus:carrot_item")
elseif minetest.get_modpath("docfarming") ~= nil then
    minetest.register_alias("mobs:carrot", "docfarming:carrot")
else
    minetest.register_craftitem(":mobs:carrot", {
        description = "Carrot",
        inventory_image = "mobs_carrot.png",
        on_use = minetest.item_eat(4),
    })
end

local rabbit_droppings = {
    name = "mobs:carrot",
    chance = 4,
    min = 1,
    max = 1,
}

mobs:register_mob("rabbit", {
    type = "animal",

    hp_max = 1,
    armor = {fleshy = 100},
    walk_velocity = 4,
    run_velocity = 4,

    spawning_nodes = {"default:dirt_with_grass"},
    max_spawn_light = 20,
    min_spawn_light = 8,
    spawn_chance = 8000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {water = 1, lava = 1, light = 0},

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=0.7, y=0.7},
    collisionbox = {-0.25, -0.33, -0.25, 0.25, 0.33, 0.25},
    textures = {"mobs_rabbit.png", "mobs_rabbit.png"},

    makes_footstep_sound = false,

    drops = {rabbit_droppings},

    on_rightclick = function(self, clicker)
        if clicker:is_player() and clicker:get_inventory() then
            clicker:get_inventory():add_item("main", "mobs:rabbit")
            self.object:remove()
        end
    end,
})

minetest.register_craftitem(":mobs:rabbit", {
    description = "Rabbit",
    inventory_image = "mobs_rabbit.png",

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.above then
            minetest.add_entity(pointed_thing.above, "mobs:rabbit")
            itemstack:take_item()
        end
        return itemstack
    end,
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:meat",
    recipe = "mobs:rabbit",
})
