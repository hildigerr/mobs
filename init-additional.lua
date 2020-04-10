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
--  Written by wulfsdad  -- December 2012 -- WTFPL -- Version 0.2
--------------------------------------------------------------------------------
----Aditional TODO:
--HIGH PRIORITY:
--		cages for pet rodents
--			feeding,breeding
--		add more animals,
--		add monsters,
--MED PRIORITY:
--		add fresh meat and remove rotten meat litter periodically
--		cheese  [additional mod: proidge, seaweed stew]
--		fork mobs and add ai tweaks, and for animals:
--			breeding & extinction possibility
--		cows lift head in water and when walking sometimes
--		cows eat grass
--LOW PRIORITY:
--		add sound effect variety
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
		tool = clicker:get_wielded_item():get_name()
		if tool == "bucket:bucket_empty" then
			clicker:get_inventory():remove_item("main", "bucket:bucket_empty")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bucket")
			if math.random(1,2) > 1 then self.milked = true	end
		elseif tool == "vessels:glass_bottle" then
			clicker:get_inventory():remove_item("main", "vessels:glass_bottle")
			clicker:get_inventory():add_item("main", "my_mobs:milk_bottle_glass")
			if math.random(1,3) > 2 then self.milked = true	end
		elseif tool == "vessels:drinking_glass" then
			clicker:get_inventory():remove_item("main", "vessles:drinking_glass")
			clicker:get_inventory():add_item("main", "my_mobs:milk_glass_cup")
			if math.random(1,4) > 3 then self.milked = true	end
		elseif tool == "vessels:steel_bottle" then
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
					minetest.chat_send_player( "singleplayer", ""..rotted) 
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
		nodenames = {  "default:chest", "default:chest_locked", }, 
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

-------------------------------------EOF----------------------------------------
