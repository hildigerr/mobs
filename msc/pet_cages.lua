--------------------------------------CAGES-------------------------------------
----Aditional TODO:
-- configurable chat message warning of pet starvation,
-- pet rodent breeding,
-- empty cage shall reset timers
-- make better cage graphics
--------------------------------------------------------------------------------
----CONFIG OPTIONS:
--Time For Cage Happenings:
local EATING_TIME = 1200 --DEFAULT: 1200 [20 min]
local DRINKING_TIME = 4 * EATING_TIME --DEFAULT: 4 * EATING_TIME
local STARVATION_LIMIT = EATING_TIME --DEFAULT: EATING_TIME 
local THIRST_LIMIT = DRINKING_TIME --DEFAULT: DRINKING_TIME
local GESTATION = DRINKING_TIME + EATING_TIME --DEFAULT: DRINKING_TIME + EATING_TIME
--------------------------------------------------------------------------------

minetest.register_node("my_mobs:cage_empty", {
	description = "Rodent Cage",
	
--		drawtype = "normal",
 	drawtype = "glasslike",
----	drawtype = "allfaces_optional",
----	drawtype = "allfaces",	
	
--	tiles = {"my_mobs_cage_top.png", "my_mobs_cage_bottom.png", "my_mobs_cage_empty_side.png",
--		"my_mobs_cage_empty_side.png", "my_mobs_cage_empty_side.png", "my_mobs_cage_empty_side.png"},
	tiles = {"my_mobs_cage_empty.png"},
--	paramtype2 = "facedir",
	sunlight_propagates = true,
--	light_source = 1,
	stack_max = 4,
	groups = {snappy=2,cracky=1,oddly_breakable_by_hand=2},
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
--	paramtype2 = "facedir",
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
--	paramtype2 = "facedir",
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