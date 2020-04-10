----Cow:
mobs:register_mob("my_mobs:cow", {
	type = "animal",
	hp_max = 8,
	collisionbox = {-0.8, -1, -0.8, 0.9, 0.55, 0.9},
	visual = "upright_sprite",
 	visual_size = {x=2.375, y=3.125},
	textures = { "my_mobs_cow.png", "my_mobs_cow.png"},
	makes_foostep_sound = true,
	walk_velocity = 1,
	armor = 3,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 2,
		max = 4,},
	},
	drawtype = "side",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 0,
	sounds = {
		random = "cow",
	},
	
	on_rightclick = function(self, clicker)
		tool = clicker:get_wielded_item():get_name()
		if tool == "bucket:bucket_empty" then
			if self.milked then
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
				})
				do return end
			else
				minetest.sound_play("milk_splash", {
					to_player = clicker:get_player_name(),
--					object = self.object,
					gain = 1.0, -- default
--					max_hear_distance = 32, -- default
--					loop = false,
				})
			end
			clicker:get_inventory():remove_item("main", "bucket:bucket_empty")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bucket")
			if math.random(1,2) > 1 then self.milked = true	end
		elseif tool == "vessels:glass_bottle" then
			if self.milked then
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
				})
				do return end
			else
				minetest.sound_play("milk_splash", {
					to_player = clicker:get_player_name(),
--					object = self.object,
					gain = 1.0, -- default
--					max_hear_distance = 32, -- default
--					loop = false,
				})
			end
			clicker:get_inventory():remove_item("main", "vessels:glass_bottle")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bottle_glass")
			if math.random(1,3) > 2 then self.milked = true	end
		elseif tool == "vessels:drinking_glass" then
			if self.milked then
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
				})
				do return end
			else
				minetest.sound_play("milk_splash", {
					to_player = clicker:get_player_name(),
--					object = self.object,
					gain = 1.0, -- default
--					max_hear_distance = 32, -- default
--					loop = false,
				})
			end
			clicker:get_inventory():remove_item("main", "vessles:drinking_glass")
			clicker:get_inventory():add_item("main", "my_mobs:milk_glass_cup")
			if math.random(1,4) > 3 then self.milked = true	end
		elseif tool == "vessels:steel_bottle" then
			if self.milked then
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
				})
				do return end
			else
				minetest.sound_play("milk_splash", {
					to_player = clicker:get_player_name(),
--					object = self.object,
					gain = 1.0, -- default
--					max_hear_distance = 32, -- default
--					loop = false,
				})
			end
			clicker:get_inventory():remove_item("main", "vessels:steel_bottle")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bottle_steel")
			if math.random(1,3) > 2 then self.milked = true end
		end -- tool ifs
	end, -- on_rightclick func
})
mobs:register_spawn("my_mobs:cow", {"default:dirt_with_grass"}, 20, 8, 6000, 2, 31000)

minetest.register_craftitem("my_mobs:milk_bucket", {
	description = "Bucket of Milk",
	image = "my_mobs_bucket_milk.png",
	on_use = minetest.item_eat(8,"bucket:bucket_empty"),
	groups = { eatable=1 },
	stack_max = 1,
})

minetest.register_craftitem("my_mobs:milk_bottle_glass", {
	description = "Bottle of Milk",
	image = "my_mobs_glass_bottle_milk.png",
	wield_image = "my_mobs_glass_bottle_milk_wield.png",
	on_use = minetest.item_eat(4, "vessels:glass_bottle"),
	groups = { eatable=1 },
})

minetest.register_craftitem("my_mobs:milk_glass_cup", {
	description = "Bottle of Milk",
	image = "my_mobs_drinking_glass_milk.png",
	wield_image = "my_mobs_drinking_glass_milk_wield.png",
	on_use = minetest.item_eat(2, "vessels:drinking_glass"),
	groups = { eatable=1 },
})

minetest.register_craftitem("my_mobs:milk_bottle_steel", {
	description = "Flask of Milk",
	image = --"vessels_steel_bottle.png",
		"my_mobs_steel_bottle_milk.png",
	on_use = minetest.item_eat(4, "vessels:steel_bottle"),
	groups = { eatable=1 },
})