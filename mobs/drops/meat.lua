
--- Craft Items ---

minetest.register_craftitem("mobs:meat_raw", {
    description = "Raw Meat",
    inventory_image = "mobs_meat_raw.png",
    on_use = function(itemstack, user, pointed_thing)
        minetest.do_item_eat(math.random(-4,2), nil, itemstack, user, pointed_thing)
    end,
    groups = { eatable=1, meat=1 },
})

minetest.register_craftitem("mobs:meat", {
    description = "Meat",
    inventory_image = "mobs_meat.png",
    on_use = minetest.item_eat(4),
    groups = { eatable=2, meat=1 },
})

minetest.register_craftitem("mobs:meat_rotten", {
    description = "Rotten Meat",
    image = "mobs_meat_rotten.png",
    on_use = minetest.item_eat(-4),
    groups = { eatable=1 },
})

minetest.register_craftitem("mobs:scorched_stuff", {
    description = "Scorched stuff",
    inventory_image = "mobs_scorched_stuff.png",
})

--- Cooking Crafts ---

minetest.register_craft({
    type = "cooking",
    output = "mobs:meat",
    recipe = "mobs:meat_raw",
    cooktime = 5,
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:scorched_stuff",
    recipe = "mobs:meat",
    cooktime = 2,
})

minetest.register_craft({
    type = "cooking",
    output = "mobs:scorched_stuff",
    recipe = "mobs:meat_rotten",
    cooktime = 3,
})

--- Dye Crafts --

minetest.register_craft({
   type = "shapeless",
   output = 'dye:grey 1',
   recipe = {
        "mobs:scorched_stuff",
    }
})

minetest.register_craft({
   type = "shapeless",
   output = 'dye:black 1',
   recipe = {
        "mobs:scorched_stuff",
        "dye:grey",
    }
})
