---------------------------OVERCOOKING RECIPES----------------------------------
minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "my_mobs:rabbit_cooked",
	cooktime = 2,
})

minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "mobs:meat",
	cooktime = 2,
})

minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "mobs:rat_cooked",
	cooktime = 2,
})

minetest.register_craft({
	type = "shapeless",
   output = 'dye:grey 1',
   recipe = {
		"default:scorched_stuff",
	}
})

minetest.register_craft({
	type = "shapeless",
   output = 'dye:black 1',
   recipe = {
		"default:scorched_stuff",
		"dye:grey",
	}
})