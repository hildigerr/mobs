--------------------------------------------------------------------------------
--
--		Additional mobs to extend upon
--			PilzAdam's Simple Mobs <http://minetest.net/forum/viewtopic.php?id=3063>
--
-- Includes:
--		Animals -- Cow (and milk), Rabbit
--		Overcooking and using the result to make dye
--		Meat spoilage if it remains uncooked
--
--NOTES:
--			Raw meet can be preserved through "cheating" or using a refridgerator
--			provided by VanessaE's Home Decor Mod
--				<http://minetest.net/forum/viewtopic.php?id=2041>
--
--			Known bugs:
--				drinking from a stack of vessels does not return an empty vessel
--
--  Written by wulfsdad  -- December 2012 -- WTFPL -- Version 0.1
--------------------------------------------------------------------------------
--Aditional TODO:
--		refactor redundant code
--		add sound effect variety
--		cheese  [additional mod: proidge, seaweed stew]
--		add more animals,
--		add monsters,
--		prevent "cheating" by hiding raw meat in the furnace or oven,
--			this should also make it seam as though you sometimes burn the meat you're cooking
--		Rot partial stacks possibility
--		cages for pet rodents
--		make chances and timer durations easily configurable

--------------------------------ANIMALS-----------------------------------------
----Cow:
mobs:register_mob("my_mobs:cow", {
	type = "animal",
	hp_max = 8,
	collisionbox = {-0.5, -1, -1.2, 0.33, 0.5, 1.1},
	visual = "upright_sprite",
 	visual_size = {x=3.5, y=3.25},
	textures = { "animal_cow_cow_item.png", "animal_cow_cow_item.png"},
	makes_foostep_sound = true,
	walk_velocity = 1,
	armor = 3,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 4,
		max = 6,},
	},
	drawtype = "side",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 0,
	sounds = {
		random = "cow",
	},
	
	on_rightclick = function(self, clicker)
		if self.milked then
			return
		end
		tool = clicker:get_wielded_item():get_name()
		if tool == "bucket:bucket_empty" then
			clicker:get_inventory():remove_item("main", "bucket:bucket_empty")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bucket")
			if math.random(1,2) > 1 then
				self.milked = true
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false, -- only sounds connected to objects can be looped
				})
			end
		elseif tool == "vessels:glass_bottle" then
			clicker:get_inventory():remove_item("main", "vessels:glass_bottle")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bottle_glass")
			if math.random(1,3) > 2 then
				self.milked = true
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false, -- only sounds connected to objects can be looped
				})
			end
		elseif tool == "vessels:drinking_glass" then
			clicker:get_inventory():remove_item("main", "vessles:drinking_glass")
			clicker:get_inventory():add_item("main", "my_mobs:milk_glass_cup")
			if math.random(1,4) > 3 then
				self.milked = true
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false, -- only sounds connected to objects can be looped
				})
			end
		elseif tool == "vessels:steel_bottle" then
			clicker:get_inventory():remove_item("main", "vessels:steel_bottle")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bottle_steel")
			if math.random(1,3) > 2 then
				self.milked = true
				minetest.sound_play("Mudchute_cow_1", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false, -- only sounds connected to objects can be looped
				})
			end
		end -- tool ifs
	end,
})
mobs:register_spawn("my_mobs:cow", {"default:dirt_with_grass"}, 20, 8, 6000, 2, 31000)

minetest.register_craftitem("my_mobs:milk_bucket", {
	description = "Bucket of Milk",
	image = "bucket_milk.png",
	on_use = minetest.item_eat(8,"bucket:bucket_empty"),
	groups = { eatable=1 },
	stack_max = 1,
})

minetest.register_craftitem("my_mobs:milk_bottle_glass", {
	description = "Bottle of Milk",
	image = "glass_bottle_milk.png",
	on_use = minetest.item_eat(4, "vessels:glass_bottle"),
	groups = { eatable=1 },
})

minetest.register_craftitem("my_mobs:milk_glass_cup", {
	description = "Bottle of Milk",
	image = "drinking_glass_milk.png",
	on_use = minetest.item_eat(2, "vessels:drinking_glass"),
	groups = { eatable=1 },
})

minetest.register_craftitem("my_mobs:milk_bottle_steel", {
	description = "Flask of Milk",
	image = "steel_bottle_milk.png",
	on_use = minetest.item_eat(4, "vessels:steel_bottle"),
	groups = { eatable=1 },
})


----Rabbit:
mobs:register_mob("my_mobs:rabbit", {
	type = "animal",
	hp_max = 1,
	collisionbox = {-0.25, -0.33, -0.25, 0.25, 0.33, 0.25},
	visual = "upright_sprite",
	visual_size = {x=0.7, y=0.7},
	textures = {"critters_animals_rabbit.png", "critters_animals_rabbit.png"},
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
	inventory_image = "critters_animals_rabbit.png",
	
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
	cooktime = 5,
})


----####:


---------------------------OVERCOOKING RECIPES----------------------------------
minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "my_mobs:rabbit_cooked",
	cooktime = 5,
})

minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "mobs:meat",
	cooktime = 5,
})

minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "mobs:rat_cooked",
	cooktime = 5,
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


---------------------------------SPOILING MEAT----------------------------------
minetest.register_craftitem("my_mobs:meat_rotten", {
	description = "Rotten Meat",
	image = "meat_rotten.png",
	on_use = minetest.item_eat(-6),
	groups = { meat=1, eatable=1 },
})

minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "my_mobs:meat_rotten",
	cooktime = 5,
})

--Refactorization: (in progress)
-- function spoil_meat( inv, warn, owner )
-- 	for i=1,inv.get_size("main") do
-- 		local item = inv:get_stack("main", i)
-- 		if item:get_name() == "mobs:meat_raw" then
-- 			item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
-- 			inv:set_stack("main", i, item)
-- 			if warn then
-- 				minetest.sound_play("ugh_rot_warn", { to_player = owner,	gain = 1.0,})
--					-- Change or have multiple strings to choose from randomly
-- 				minetest.chat_send_player( owner, "Something in your inventory is starting to smell bad!") 
-- 			end -- if warn
-- 		end -- if found raw meat
-- 	end -- for each inv slot [i]
-- end -- spoil_meat func


--Rot Stored Meat
minetest.register_abm({
	 nodenames = { "default:chest", "default:chest_locked", 
-- 						"homedecor:kitchen_cabinet", "homedecor:kitchen_cabinet_half",
-- 						"homedecor:kitchen_cabinet_with_sink", "homedecor:nightstand_oak_one_drawer",
-- 						"homedecor:nightstand_oak_two_drawers", "homedecor:nightstand_mahogany_one_drawer",
-- 						"homedecor:nightstand_mahogany_two_drawers", 
					 }, -- add homedecor to depends.txt if you want to use these
    interval = 720, -- (operation interval)
    chance = 3, -- (chance of trigger is 1.0/this)
    action = function(pos, node)
		local contents = minetest.env:get_meta(pos):get_inventory()
--		spoil_meat( contents, false, nil )
 		for i=1,contents:get_size("main") do
			local item = contents:get_stack("main", i)
			if item:get_name() == "mobs:meat_raw" then
				item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
				contents:set_stack("main", i, item)
			end -- if found raw meat
		end -- for each item within chest [i]
	 end -- action func
})
--TODO: Make so you cant hide meat in:
--"default:furnace","homedecor:oven"


--Rot Held Meat
local rotting_timer = 0
minetest.register_globalstep( function(dtime)
	rotting_timer = rotting_timer + dtime
	if rotting_timer >= 720 then --TEST WiTH: 2 then --
		for _,player in ipairs(minetest.get_connected_players()) do
			local who = player:get_player_name()
			local stuff = player:get_inventory()
 			for i=1,stuff:get_size("main") do
 				local item = stuff:get_stack("main", i)
 				if item:get_name() == "mobs:meat_raw" then
--					for j=1,item:get_count() do --TODO: Rot partial stacks
 						if math.random(1,100) > 66 then -- about 1/3 chance
 							item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
							stuff:set_stack("main", i, item)
							--TODO: Change or have multiple strings to choose from randomly:
							minetest.sound_play("ugh_rot_warn", { to_player = who,	gain = 1.0,})
							minetest.chat_send_player(who, "Something in your inventory is starting to smell bad!") 
 						end -- if by random chance
--					end -- for each item in stack [j]
 				end -- if is meat
 			end -- for each (32) inventory slot [i]
			for i=1,stuff:get_size("craft") do
				item = stuff:get_stack("craft", i)
 				if item:get_name() == "mobs:meat_raw" then
					if math.random(1,100) > 66 then -- about 1/3 chance
						item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
						stuff:set_stack("craft", i, item)
						--TODO: Change or have multiple strings to choose from randomly:
						minetest.sound_play("ugh_rot_warn", { to_player = who,	gain = 1.0,})
						minetest.chat_send_player(who, "Something in your inventory is starting to smell bad!") 
					end -- if by random chance
 				end -- if is meat
			end -- for each (9) craft slot [i]
		end -- for each player		
		rotting_timer = 0 --reset the timer
	end -- timer
end)


--Rot Droped Meat
minetest.register_abm({
	 nodenames = {"air"},
	 neighbors = { "group:stone", "group:sand",
						--"group:soil" : 
						"default:dirt_with_grass", "default:dirt_with_grass_footsteps", "default:dirt", 
						--etc:
						"default:gravel", "default:sandstone", "default:clay",
						"default:brick", "default:wood", 
	 }, 
    interval = 360, -- (operation interval)
    chance = 1, -- (chance of trigger is 1.0/this)
    action = function(pos, node)
		local objs = minetest.env:get_objects_inside_radius(pos, 1)
		if objs then
			for i,j in ipairs(objs) do
				local k = j:get_luaentity()
				if k then
					local str = k.itemstring
					if str ~= nil then
						if str == "mobs:meat_raw" then
							if math.random(1,100) > 66 then -- about 1/3 chance --TESTING
								objs[i]:remove()
								minetest.env:add_item(pos, "my_mobs:meat_rotten")
							end -- if by chance
						end -- if is meat
					end -- itemstring exists
				end -- luaidentity exists
			end -- for objs
		end -- objects exist
	 end -- func
})

minetest.register_abm({
	 nodenames = {"default:water_source", "default:water_flowing"},
	 neighbors = { "group:stone", "group:sand",
						--"group:soil" : 
						"default:dirt_with_grass", "default:dirt_with_grass_footsteps", "default:dirt", 
						--etc:
						"default:gravel", "default:sandstone", "default:clay",
						"default:brick", "default:wood", 
	 }, 
    interval = 240, -- (operation interval)
    chance = 1, -- (chance of trigger is 1.0/this)
    action = function(pos, node)
		local objs = minetest.env:get_objects_inside_radius(pos, 1)
		if objs then
			for i,j in ipairs(objs) do
				local k = j:get_luaentity()
				if k then
					local str = k.itemstring
					if str ~= nil then
						if str == "mobs:meat_raw" then
							if math.random(1,100) > 50 then -- about 1/3 chance --TESTING
								objs[i]:remove()
								minetest.env:add_item(pos, "my_mobs:meat_rotten")
							end -- if by chance
						end -- if is meat
					end -- itemstring exists
				end -- luaidentity exists
			end -- for objs
		end -- objects exist
	 end -- func
})

-------------------------------------EOF----------------------------------------
