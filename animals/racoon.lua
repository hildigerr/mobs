--TODO:
    --drop furs and craft coonskin hats and taxedermy

----Racoons:
mobs:register_mob("mobs:racoon", {
    type = "animal",

    hp_max = 3,
    armor = 80,
    view_range = 15,
    walk_velocity = 2,
    run_velocity = 2,

    water_damage = 1,
    lava_damage = 1,
    light_damage = 0,

    visual = "upright_sprite",
    drawtype = "front",
    visual_size = {x=0.7, y=0.7},
    collisionbox = {-0.25, -0.33, -0.25, 0.25, 0.33, 0.25},
    textures = {"mobs_racoon.png", "mobs_racoon.png"},

    makes_footstep_sound = false,

    drops = {
        {
            name = "default:apple",
            chance = 4,
            min = 1,
            max = 1,
        },
    },

    on_rightclick = function(self, clicker)
        if self.type == "animal" then
            self.type = "monster"
            self.attack_method = function(self, target)
                mobs:slap(self, target.player, {fleshy=1})
            end
        end
    end,
})
mobs:register_spawn("mobs:racoon", {"default:dirt_with_grass"}, 20, 8, 8000, 1, 31000)
