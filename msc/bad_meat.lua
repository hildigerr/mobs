---------------------------------SPOILING MEAT----------------------------------

----CONFIG OPTIONS:
--Chances of meat rotting [1-100] Lower number = Greater chance
--if math.random(1,100) > CHANCE then it will rot
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
--------------------------------------------------------------------------------

minetest.register_craftitem("my_mobs:meat_rotten", {
	description = "Rotten Meat",
	image = "my_mobs_meat_rotten.png",
	on_use = minetest.item_eat(-6),
	groups = { meat=1, eatable=1 },
})

minetest.register_craft({
	type = "cooking",
	output = "scorched_stuff",
	recipe = "my_mobs:meat_rotten",
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

-------------------------------------EOF----------------------------------------