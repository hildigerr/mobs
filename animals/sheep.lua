
mobs:register_mob("mobs:sheep", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.6, -0.625, -0.6, 0.6, 0.625, 0.6},
	visual = "upright_sprite",
	visual_size = {x=2, y=1.25},
	textures = {"mobs_sheep.png", "mobs_sheep.png"},
	makes_footstep_sound = true,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
	},
	drawtype = "side",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	sounds = {
		random = "mobs_sheep",
	},
	follow = "farming:wheat",
	view_range = 5,
	
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item:get_name() == "farming:wheat" then
			if not self.tamed then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				self.tamed = true
			elseif self.naked then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				self.food = (self.food or 0) + 1
				if self.food >= 8 then
					self.food = 0
					self.naked = false
					self.object:set_properties({
				textures = {"mobs_sheep.png", "mobs_sheep.png"},
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
				textures = {"mobs_sheep_naked.png", "mobs_sheep_naked.png"},
			})
		end
	end,
})
mobs:register_spawn("mobs:sheep", {"default:dirt_with_grass"}, 20, 8, 9000, 1, 31000)
