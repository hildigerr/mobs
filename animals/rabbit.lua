----Rabbit:
mobs:register_mob("my_mobs:rabbit", {
	type = "animal",
	hp_max = 1,
	collisionbox = {-0.25, -0.33, -0.25, 0.25, 0.33, 0.25},
	visual = "upright_sprite",
	visual_size = {x=0.7, y=0.7},
	textures = {"my_mobs_rabbit.png", "my_mobs_rabbit.png"},
	makes_footstep_sound = false,
	walk_velocity = 4,
	armor = 3,
	drops = {
		{name = "default:apple",
		chance = 4,
		min = 1,
		max = 1,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "my_mobs:rabbit")
			self.object:remove()
		end
	end,
})
mobs:register_spawn("my_mobs:rabbit", {"default:dirt_with_grass"}, 20, 8, 8000, 1, 31000)

minetest.register_craftitem("my_mobs:rabbit", {
	description = "Rabbit",
	inventory_image = "my_mobs_rabbit.png",
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "my_mobs:rabbit")
			itemstack:take_item()
		end
		return itemstack
	end,
})
	
minetest.register_craftitem("my_mobs:rabbit_cooked", {
	description = "Cooked Rabbit",
	inventory_image = "my_mobs_cooked_rabbit.png",
	
	on_use = minetest.item_eat(5),
})

minetest.register_craft({
	type = "cooking",
	output = "my_mobs:rabbit_cooked",
	recipe = "my_mobs:rabbit",
})
