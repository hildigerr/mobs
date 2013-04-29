local USE_SPRITES = minetest.settings:get_bool("mobs.use_sprites", false)

mobs:register_mob("mobs:dungeon_master", {
    type = "monster",

    hp_max = 10,
    armor = 50,
    view_range = 15,
    walk_velocity = 1,
    run_velocity = 3,

    water_damage = 1,
    lava_damage = 1,
    light_damage = 0,

    visual = USE_SPRITES and "upright_sprite" or "mesh",
    drawtype = "front",
    mesh = "mobs_dungeon_master.x",
    visual_size = USE_SPRITES and {x=1.875, y=2.4375} or {x=8, y=8},
    collisionbox = USE_SPRITES and {-0.8, -1.21875, -0.8, 0.8, 1.21875, 0.8} or {-0.7, -0.01, -0.7, 0.7, 2.6, 0.7},
    textures = USE_SPRITES and {"mobs_dungeon_master.png", "mobs_dungeon_master_back.png"} or {"mobs_dungeon_master_mesh.png"},
    animation = not USE_SPRITES and {
        stand_start = 0,
        stand_end = 19,
        walk_start = 20,
        walk_end = 35,
        punch_start = 36,
        punch_end = 48,
        speed_normal = 15,
        speed_run = 15,
    },

    sounds = {
        attack = "mobs_fireball",
    },
    makes_footstep_sound = true,

    drops = {
        {name = "default:mese",
        chance = 100,
        min = 1,
        max = 2,},
    },

    attack_range = 10,
    attack_method = function(self, target)
        local shoot_interval = 2.5
        if self.timer > shoot_interval and math.random(1, 100) <= 60 then
            local p = self.object:get_pos()
            if not USE_SPRITES then
               p.y = p.y + (self.collisionbox[2]+self.collisionbox[5])/2
            end
            mobs:shoot("mobs:fireball", p, target.pos)
            self.timer = 0
            return true
        end
        return false
    end,
})
mobs:register_spawn("mobs:dungeon_master", {"default:stone"}, 2, -1, 7000, 1, -50)

mobs:register_arrow("mobs:fireball", {
    visual = "sprite",
    visual_size = {x=1, y=1},
    --textures = {{name="mobs_fireball.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}}}, FIXME
    textures = {"mobs_fireball.png"},
    velocity = 5,
    hit_player = function(self, player)
        local s = self.object:get_pos()
        local p = player:get_pos()
        local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
        player:punch(self.object, 1.0,  {
            full_punch_interval=1.0,
            damage_groups = {fleshy=4},
        }, vec)
        local pos = self.object:get_pos()
        for dx=-1,1 do
            for dy=-1,1 do
                for dz=-1,1 do
                    local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    local n = minetest.get_node(pos).name
                    if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
                        minetest.set_node(p, {name="fire:basic_flame"})
                    else
                        minetest.remove_node(p)
                    end
                end
            end
        end
    end,
    hit_node = function(self, pos, node)
        for dx=-1,1 do
            for dy=-2,1 do
                for dz=-1,1 do
                    local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    local n = minetest.get_node(pos).name
                    if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
                        minetest.set_node(p, {name="fire:basic_flame"})
                    else
                        minetest.remove_node(p)
                    end
                end
            end
        end
    end
})
