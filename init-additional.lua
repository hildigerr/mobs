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
--  Written by wulfsdad  -- December 2012 -- WTFPL -- Version 0.3
--------------------------------------------------------------------------------
----Aditional TODO:
--HIGH PRIORITY:
--		add more animals,
--		add monsters,
--		cheese  [additional mod: proidge, seaweed stew]
--		support more food,
--		pet rodent breeding,
--		configurable chat message warning of pet starvation,
--MED PRIORITY:
--		add fresh meat and remove rotten meat litter periodically
--		cheese  [additional mod: proidge, seaweed stew]
--		fork mobs and add ai tweaks, and for animals:
--			breeding & extinction possibility
--		cows lift head in water and when walking sometimes
--		cows eat grass
--		Separate init file into multiple files
--			add config settings to load only parts desired
--		empty cage shall reset timers
--LOW PRIORITY:
--		add sound effect variety
--		make better cage graphics
--------------------------------------------------------------------------------
----CONFIG OPTIONS:
--Chances of meat rotting [1-100] Lower number = Greater chance
--if math.random(1,100) > CHANCE then   it will rot
local ROT_IN_WATER_CHANCE = 50 --DEFAULT:50
local ROT_ON_GROUND_CHANCE = 66 --DEFAULT:66
local ROT_IN_POCKET_CHANCE = 66 --DEFAULT:66
local ROT_IN_STORAGE_CHANCE = 66 --DEFAULT:66
local ROT_WHILE_COOKING_CHANCE = 66 --DEFAULT:66
--Time to Rot intervals
--Aproximetley equivalent to seconds
local WATER_TIMER = 240 --DEFAULT:240 [4 min]
local GROUND_TIMER = 360 --DEFAULT:360 [6 min]
local POCKET_TIMER = 720 --DEFAULT:720 [12 min]
local STORAGE_TIMER = 720 --DEFAULT:720 [12 min]

--Time For Cage Happenings:
local EATING_TIME = 1200 --DEFAULT: 1200 [20 min]
local DRINKING_TIME = 4 * EATING_TIME --DEFAULT: 4 * EATING_TIME
local STARVATION_LIMIT = EATING_TIME --DEFAULT: EATING_TIME 
local THIRST_LIMIT = DRINKING_TIME --DEFAULT: DRINKING_TIME
local GESTATION = DRINKING_TIME + EATING_TIME --DEFAULT: DRINKING_TIME + EATING_TIME
-- --Rabbit:
-- local GESTATION_RABBIT = 3600 --DEFAULT: 3600
-- local MAX_LITTER_SIZE_RABBIT = 2 --DEFAULT: 2
-- --Rat:
-- local GESTATION_RAT = 3600 --DEFAULT: 3600
-- local MAX_LITTER_SIZE_RAT = 4 --DEFAULT: 4

--------------------------------ANIMALS-----------------------------------------
----Cow:
mobs:register_mob("my_mobs:cow", {
	type = "animal",
	hp_max = 8,
	collisionbox = {-0.8, -1, -0.8, 0.9, 0.55, 0.9},
	visual = "upright_sprite",
 	visual_size = {x=2.375, y=3.125},
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
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
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
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
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
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
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
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
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


function spoil_meat( inv, title, chance, warn, owner )
--inv = InvRef
--title = listname (string)-- TODO: make handle lists
--chance = [1-100]
--warn = boolean
--owner = player name (string)
   	for i=1,inv:get_size(title) do
  		local item = inv:get_stack(title, i)
  		if item:get_name() == "mobs:meat_raw" then
 			local qt = item:get_count()
			local rotted = 0
 			for j=1,qt do
 				if math.random(1,100) > chance then
 					rotted = rotted +1
--					minetest.chat_send_player( "singleplayer", ""..rotted) 
 				end -- if by chance
 			end -- end count rotten portion of stack
 			if rotted ~= 0 then
				if rotted < qt then
					if inv:room_for_item(title, ItemStack{name = "my_mobs:meat_rotten", count = rotted, wear=0, metadata=""}) then
						item:take_item(rotted)
						inv:add_item(title, ItemStack({name = "my_mobs:meat_rotten", count = rotted, wear=0, metadata=""}))
					else -- not enough room
						--so rot it all:
						item:replace({name = "my_mobs:meat_rotten", count = qt, wear=0, metadata=""})
					end -- room for nu_stack if
				else -- rotted == qt
					item:replace({name = "my_mobs:meat_rotten", count = qt, wear=0, metadata=""})
				end -- if rotted < qt
				inv:set_stack(title, i, item)
				if warn then
					minetest.sound_play("ugh_rot_warn", { to_player = owner,	gain = 1.0,})
					-- Change or have multiple strings to choose from randomly:
					minetest.chat_send_player( owner, "Something in your inventory is starting to smell bad!") 
				end -- if warn
 			end -- if some meat spoiled
  		end -- if found raw meat
  	end -- for each inv slot [i]
end -- spoil_meat func


--Rot Stored Meat
if not minetest.get_modpath("homedecor") then
	minetest.register_abm({
		nodenames = {  "default:chest", "default:chest_locked",
							"my_mobs:cage_empty", "my_mobs:cage_rat", "my_mobs:cage_rabbit",
						}, 
		interval = STORAGE_TIMER, -- (operation interval)
		chance = 1, -- (chance of trigger is 1.0/this)
		action = function(pos, node)
			spoil_meat( minetest.env:get_meta(pos):get_inventory(),
							"main",
							ROT_IN_STORAGE_CHANCE,
							false, nil )
		end -- action func
	})
	minetest.register_abm({
		nodenames = { "default:furnace" },
		interval = STORAGE_TIMER, -- (operation interval)
		chance = 1, -- (chance of trigger is 1.0/this)
		action = function(pos, node)
			spoil_meat( minetest.env:get_meta(pos):get_inventory(), 
							"fuel",
							ROT_WHILE_COOKING_CHANCE,
							false, nil )
			spoil_meat( minetest.env:get_meta(pos):get_inventory(),
							"src",
							ROT_WHILE_COOKING_CHANCE,
							false, nil )							
			spoil_meat( minetest.env:get_meta(pos):get_inventory(),
							"dst",
							ROT_WHILE_COOKING_CHANCE,
							false, nil )			
		end -- action func
	})
else
	minetest.register_abm({
		nodenames = {  "default:chest", "default:chest_locked", 
							"homedecor:kitchen_cabinet", "homedecor:kitchen_cabinet_half",
							"homedecor:kitchen_cabinet_with_sink", "homedecor:nightstand_oak_one_drawer",
							"homedecor:nightstand_oak_two_drawers", "homedecor:nightstand_mahogany_one_drawer",
							"homedecor:nightstand_mahogany_two_drawers",
							"my_mobs:cage_empty", "my_mobs:cage_rat", "my_mobs:cage_rabbit",
						},
		interval = STORAGE_TIMER, -- (operation interval)
		chance = 1, -- (chance of trigger is 1.0/this)
		action = function(pos, node)
			spoil_meat( minetest.env:get_meta(pos):get_inventory(),
							"main",
							ROT_IN_STORAGE_CHANCE,
							false, nil )
		end -- action func
	})
	minetest.register_abm({
		nodenames = { "default:furnace","homedecor:oven" },
		interval = STORAGE_TIMER, -- (operation interval)
		chance = 1, -- (chance of trigger is 1.0/this)
		action = function(pos, node)
			spoil_meat( minetest.env:get_meta(pos):get_inventory(),
							"fuel",
							ROT_WHILE_COOKING_CHANCE,
							false, nil )
			spoil_meat( minetest.env:get_meta(pos):get_inventory(),
							"src",
							ROT_WHILE_COOKING_CHANCE,
							false, nil )							
			spoil_meat( minetest.env:get_meta(pos):get_inventory(),
							"dst",
							ROT_WHILE_COOKING_CHANCE,
							false, nil )			
		end -- action func
	})
end


--Rot Held Meat
local rotting_timer = 0
minetest.register_globalstep( function(dtime)
	rotting_timer = rotting_timer + dtime
	if rotting_timer >= POCKET_TIMER then --TEST WiTH: 2 then --
		for _,player in ipairs(minetest.get_connected_players()) do
			local who = player:get_player_name()
			local stuff = player:get_inventory()
 			spoil_meat(stuff, "main", ROT_IN_POCKET_CHANCE, true, who)
 			spoil_meat(stuff, "craft", ROT_IN_POCKET_CHANCE, true, who)
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
    interval = GROUND_TIMER, -- (operation interval)
    chance = 1, -- (chance of trigger is 1.0/this)
    action = function(pos, node)
		local objs = minetest.env:get_objects_inside_radius(pos, 1)
		if objs then
			for i,j in ipairs(objs) do
				local k = j:get_luaentity()
				if k then
					local str = k.itemstring
					if str ~= nil then
-- 						if str == "my_mobs:meat_rotten" then -- add fresh meat and reimplement
-- 							objs[i]:remove()
-- 						else
						if str == "mobs:meat_raw" then
							if math.random(1,100) > ROT_ON_GROUND_CHANCE then -- about 1/3 chance --TESTING
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
    interval = WATER_TIMER, -- (operation interval)
    chance = 1, -- (chance of trigger is 1.0/this)
    action = function(pos, node)
		local objs = minetest.env:get_objects_inside_radius(pos, 1)
		if objs then
			for i,j in ipairs(objs) do
				local k = j:get_luaentity()
				if k then
					local str = k.itemstring
					if str ~= nil then
-- 						if str == "my_mobs:meat_rotten" then
-- 							objs[i]:remove()
-- 						else
						if str == "mobs:meat_raw" then
							if math.random(1,100) > ROT_IN_WATER_CHANCE then
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


--------------------------------------CAGES-------------------------------------

minetest.register_node("my_mobs:cage_empty", {
	description = "Rodent Cage",
	
--		drawtype = "normal",
 	drawtype = "glasslike",
----	drawtype = "allfaces_optional",
----	drawtype = "allfaces",	
	
--	tiles = {"my_mobs_cage_top.png", "my_mobs_cage_bottom.png", "my_mobs_cage_empty_side.png",
--		"my_mobs_cage_empty_side.png", "my_mobs_cage_empty_side.png", "my_mobs_cage_empty_side.png"},
	tiles = {"my_mobs_cage_empty.png"},
	paramtype2 = "facedir",
	sunlight_propagates = true,
--	light_source = 1,
	groups = {snappy=2,cracky=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = {},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
			"size[8,9;]"..		
			"list[current_name;drink;5,1;1,1;]"..
			"list[current_name;feed;2,2;1,1;]"..
			"list[current_name;house;3,1;2,2;]"..
			"list[current_player;main;0,5;8,4;]"
		)
		meta:set_string("infotext", "Cage")
		local inv = meta:get_inventory()
		inv:set_size("house", 2*2)
		inv:set_size("feed",1)
		inv:set_size("drink",1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("house") then
			return false
		elseif not inv:is_empty("feed") then
			return false
		elseif not inv:is_empty("drink") then
			return false
		end
		return true
	end,
})

minetest.register_craft({
	output = 'my_mobs:cage_empty',
	recipe = {
		{'group:wood', 'group:wood', 'group:wood'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

minetest.register_node("my_mobs:cage_rat", {
	description = "Rodent Cage",
 	drawtype = "glasslike",
	tiles = {"my_mobs_cage_rat.png"},
	paramtype2 = "facedir",
	sunlight_propagates = true,
	drop = "my_mobs:cage_empty",
	groups = {snappy=2,cracky=2,oddly_breakable_by_hand=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = {},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
			"size[8,9;]"..
			"list[current_name;drink;5,1;1,1;]"..
			"list[current_name;feed;2,2;1,1;]"..
			"list[current_name;house;3,1;2,2;]"..
			"list[current_player;main;0,5;8,4;]"
		)
		meta:set_string("infotext", "Rat Cage");
		local inv = meta:get_inventory()
		inv:set_size("house", 2*2)
		inv:set_size("feed",1)
		inv:set_size("drink",1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("house") then
			return false
		elseif not inv:is_empty("feed") then
			return false
		elseif not inv:is_empty("drink") then
			return false
		end
		return true
	end,
})

minetest.register_node("my_mobs:cage_rabbit", {
	description = "Rodent Cage",
 	drawtype = "glasslike",
	tiles = {"my_mobs_cage_rabbit.png"},
	paramtype2 = "facedir",
	sunlight_propagates = true,
	drop = "my_mobs:cage_empty",
	groups = {snappy=2,cracky=2,oddly_breakable_by_hand=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = {},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
			"size[8,9;]"..
			"list[current_name;drink;5,1;1,1;]"..
			"list[current_name;feed;2,2;1,1;]"..
			"list[current_name;house;3,1;2,2;]"..
			"list[current_player;main;0,5;8,4;]"
		)
		meta:set_string("infotext", "Rat Cage");
		local inv = meta:get_inventory()
		inv:set_size("house", 2*2)
		inv:set_size("feed",1)
		inv:set_size("drink",1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("house") then
			return false
		elseif not inv:is_empty("feed") then
			return false
		elseif not inv:is_empty("drink") then
			return false
		end
		return true
	end,
})

minetest.register_abm({
	nodenames = {"my_mobs:cage_empty"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node)
		local meta = minetest.env:get_meta(pos) 
		local inv = meta:get_inventory()
		if inv:contains_item("house", "my_mobs:rabbit") then
			hacky_swap_node(pos,"my_mobs:cage_rabbit")
		elseif inv:contains_item("house", "mobs:rat") then
			hacky_swap_node(pos,"my_mobs:cage_rat")
-- 		else --DOESNT WORK
-- 			for i, name in ipairs({
-- 				"breeding_totaltime",
-- 				"breeding_time",
-- 				"eating_totaltime",
-- 				"eating_time",
-- 				"drinking_totaltime",
-- 				"drinking_time"
-- 			}) do
-- 				if not meta:get_string(name) == "" then
-- 					meta:set_float(name, 0.0)
-- 				end -- if name needs reset
-- 			end -- for do
		end -- swap or set ifs
	end,
})

minetest.register_abm({
	nodenames = {"my_mobs:cage_rabbit","my_mobs:cage_rat"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node)
		local meta = minetest.env:get_meta(pos)
		for i, name in ipairs({
				"breeding_totaltime",
				"breeding_time",
				"eating_totaltime",
				"eating_time",
				"drinking_totaltime",
				"drinking_time"
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
--			minetest.chat_send_player( "singleplayer", name.." "..meta:get_float(name)) --BARF
		end
		
		local inv = meta:get_inventory()
		local occupant = nil
		
		if inv:contains_item("house", "my_mobs:rabbit") then
			occupant = "my_mobs:rabbit"
		elseif inv:contains_item("house", "mobs:rat") then
			occupant = "mobs:rat"
		else -- no occupant
			hacky_swap_node(pos,"my_mobs:cage_empty")
		end -- if animal occupant
		
		if occupant then
--			minetest.chat_send_player( "singleplayer", occupant) --BARF
			--Drinking:
			if meta:get_float("drinking_time") < meta:get_float("drinking_totaltime") then -- comsuming drink
				if inv:contains_item("drink", "bucket:bucket_water") then -- drink hasn't been removed
					meta:set_float("drinking_time", meta:get_float("drinking_time") + 1)	
				else -- drink has been removed early
					meta:set_float("drinking_totaltime", 0.0)
				end -- cheating attempt if
			elseif meta:get_float("drinking_totaltime") > 0.0 then -- consumed the drink
				meta:set_float("drinking_totaltime", 0.0)
				if inv:contains_item("drink", "bucket:bucket_water") then -- drink available
					inv:remove_item("drink", "bucket:bucket_water")
					inv:add_item("drink", "bucket:bucket_empty")
					meta:set_float("drinking_time", 0.0)
-- 				else -- drink was removed early kill them all for punishment
-- 					for i=1,inv:get_size("house") do
-- 						local item = inv:get_stack("house", i)
-- 						if item:get_name() == "my_mobs:rabbit" then 
-- 							item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
-- 							inv:set_stack("house", i, item)
-- 						end -- if dead animal exists here
-- 					end -- for each inventory slot
				end -- if there was drink
			elseif meta:get_float("drinking_time") > 0.0 then -- dying of thirst
				if inv:contains_item("drink", "bucket:bucket_water") then -- saved just in time
					meta:set_float("drinking_totaltime", DRINKING_TIME)
					if meta:get_float("drinking_time") > meta:get_float("drinking_totaltime") then -- THIRST_TIME > DRINKING_TIME [non default]
						inv:remove_item("drink", "bucket:bucket_water")
						inv:add_item("drink", "bucket:bucket_empty")
						meta:set_float("drinking_time", meta:get_float("drinking_time") - meta:get_float("drinking_totaltime") )
						meta:set_float("drinking_totaltime", 0.0 )
					end -- Drink if Thirsty
					
				else						
					if meta:get_float("drinking_time") < THIRST_LIMIT then
						meta:set_float("drinking_time", meta:get_float("drinking_time") + 1)
					else -- died of thirst
						for i=1,inv:get_size("house") do
							local item = inv:get_stack("house", i)
							if item:get_name() == occupant then 
								item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
								inv:set_stack("house", i, item)
							end -- if dead animal exists here
						end -- for each inventory slot
						meta:set_float("drinking_time", 0.0)
						meta:set_float("drinking_totaltime", 0.0)
--						meta:set_float("eating_time", 0.0)
--						meta:set_float("eating_totaltime", 0.0)				
					end -- if starvation limit
				end -- if food became availible	
			else -- not yet drinking -- both timers == 0.0
				if inv:contains_item("drink", "bucket:bucket_water") then -- start drinking
					meta:set_float("drinking_totaltime", DRINKING_TIME)
				else -- start thirsting
					meta:set_float("drinking_time", meta:get_float("drinking_time") + 1)
				end -- if drink available
			end -- drinking		
			
			--Eating:
			if meta:get_float("eating_time") < meta:get_float("eating_totaltime") then -- comsuming food
				if inv:contains_item("feed", "default:apple") then -- food hasn't been removed
					meta:set_float("eating_time", meta:get_float("eating_time") + 1)
				else -- food has been removed early
					meta:set_float("eating_totaltime", 0.0)
				end -- cheating attempt if 
			elseif meta:get_float("eating_totaltime") > 0.0 then -- consumed the food
				meta:set_float("eating_totaltime", 0.0)
				if inv:contains_item("feed", "default:apple") then
					inv:remove_item("feed", "default:apple")
					meta:set_float("eating_time", 0.0)
-- 					else -- food was removed early kill them all for punishment
-- 						for i=1,inv:get_size("house") do
-- 							local item = inv:get_stack("house", i)
-- 							if item:get_name() == "my_mobs:rabbit" then 
-- 								item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
-- 								inv:set_stack("house", i, item)
-- 							end -- if starved animal exists here
-- 						end -- for each inventory slot
				end -- if there was food
			elseif meta:get_float("eating_time") > 0.0 then -- starving
				if inv:contains_item("feed", "default:apple") then -- saved just in time
					meta:set_float("eating_totaltime", EATING_TIME)
					if meta:get_float("eating_time") > meta:get_float("eating_totaltime") then -- STARVING_TIME > EATING_TIME [non default]
						inv:remove_item("feed", "default:apple")
						meta:set_float("eating_time", meta:get_float("eating_time") - meta:get_float("eating_totaltime") )
						meta:set_float("eating_totaltime", 0.0)
					end -- Eat if Starving
				else						
					if meta:get_float("eating_time") < STARVATION_LIMIT then
						meta:set_float("eating_time", meta:get_float("eating_time") + 1)
					else -- starved
						for i=1,inv:get_size("house") do
							local item = inv:get_stack("house", i)
							if item:get_name() == occupant then 
								item:replace({name = "my_mobs:meat_rotten", count = item:get_count(), wear=0, metadata=""})
								inv:set_stack("house", i, item)
							end -- if starved animal exists here
						end -- for each inventory slot
						meta:set_float("eating_time", 0.0)
						meta:set_float("eating_totaltime", 0.0)
--							meta:set_float("drinking_time", 0.0)
--							meta:set_float("drinking_totaltime", 0.0)			
					end -- if starvation limit
				end -- if food became availible	
			else -- not consuming food -- both timers == 0.0
				if inv:contains_item("feed", "default:apple") then -- start eating
					meta:set_float("eating_totaltime", EATING_TIME)
				else -- start starving
					meta:set_float("eating_time", meta:get_float("eating_time") + 1)
				end -- if food available
			end -- consuming food
		
			--Breeding:  [CRASHES]
-- 			if meta:get_float("breeding_time") < meta:get_float("breeding_totaltime") then -- breeding
-- 				meta:set_float("breeding_time", meta:get_float("breeding_time") + 1)	
-- 			elseif meta:get_float("breeding_totaltime") > 0.0 then -- done breeding
-- 				local n = MAX_LITTER_SIZE
-- 				while n > 0 do -- get the largest litter possible
-- 					if inv:room_for_item("house",occupant.." "..n) then
-- 						inv:add_item("house", occupant.." "..n)
-- 						n = 0 -- done try no more
-- 					else -- n is too big
-- 						n = n - 1
-- 					end -- n if
-- 					meta:set_float("breeding_time", 0.0)
-- 					meta:set_float("breeding_totaltime", 0.0)
-- 				end -- n while
-- 			else -- not breeding yet -- both timers == 0.0
-- 				if inv:contains_item("house", occupant.." 2") then
-- 					meta:set_float("breeding_totaltime", GESTATION_RABBIT)
-- 				end -- couple if
-- 			end -- breeding if
				
		else -- empty house (redundant)
--			hacky_swap_node(pos,"my_mobs:cage_empty")
		end
	end,
})

-------------------------------------EOF----------------------------------------
