local turtle_setting = minetest.settings:get("mobs.turtles") or "disabled"

--turtle: 1-50 doing nothing, 60-90 running, 95-100 hidden, 105-135 swimming

mobs:register_mob("turtle", {
    type = "animal",

    hp_max = 12,
    armor = {crumbly = 5, cracky = 25, choppy = 50, fleshy = 60},
    walk_velocity = 1,

    damage = {fall = 1, water = 0, lava = 6, light = 0},

    visual = "mesh",
    drawtype = "front",
    mesh = "mobs_turtle.x",
    visual_size = {x=1.5, y=1.5},
    collisionbox = {-0.7, -0.01, -0.4, 0.7, 1.4, 0.4},
    textures = {"mobs_turtle_mesh.png"},
    animation = {
        speed_normal = 5,
        stand_start = 1,
        stand_end = 50,
        walk_start = 60,
        walk_end = 90,
        punch_start = 95,
        punch_end = 100,
    },

    makes_footstep_sound = false,

    drops = {},

}, turtle_setting == "disabled")

