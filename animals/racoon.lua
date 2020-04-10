--TODO:
	--drop furs and craft coonskin hats and taxedermy

----Racoons:
mobs:register_mob("my_mobs:racoon", {
	type = "animal",
	hp_max = 3,
	collisionbox = {-0.25, -0.33, -0.25, 0.25, 0.33, 0.25},
	visual = "upright_sprite",
	visual_size = {x=0.7, y=0.7},
	textures = {"my_mobs_racoon.png", "my_mobs_racoon.png"},
	makes_footstep_sound = false,
	walk_velocity = 2,
	run_velocity = 2,
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
	
	view_range = 15,
	damage = 1,
	attack_type = "dogfight",

 	on_rightclick = function(self, clicker)
		if self.type == "animal" then
			self.type = "monster"
		end	
 	end,
})
mobs:register_spawn("my_mobs:racoon", {"default:dirt_with_grass"}, 20, 8, 8000, 1, 31000)