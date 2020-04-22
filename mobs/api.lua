
function mobs:register_mob(name, def, disabled)
    name = "mobs:"..name
    minetest.register_entity(":"..name, {
        type = def.type,
        physical = true,
        state = "stand",
        tamed = false,

        hp_max = def.hp_max,
        armor = def.armor,
        view_range = def.view_range,
        walk_velocity = def.walk_velocity,
        run_velocity = def.run_velocity or def.walk_velocity,

        damage = def.damage,

        visual = def.visual,
        drawtype = def.drawtype,
        visual_size = def.visual_size,
        collisionbox = def.collisionbox,
        textures = def.textures,
        mesh = def.mesh,
        animation = def.animation,

        sounds = def.sounds,
        makes_footstep_sound = def.makes_footstep_sound,
        follow = def.follow,
        try_jump = def.try_jump or function(self)
            local speed = self.get_velocity(self)
            local v = self.object:get_velocity()
            if speed <= 0.5 and v.y == 0 then
                v.y = 5
                self.object:set_velocity(v)
            end
        end,

        drops = def.drops,

        attack_range = def.attack_range or 2,
        attack = def.attack or
            function(self, target)
                if self.timer > 1 then
                    self.timer = 0
                    -- return true -- To trigger animation and sound
                end
                return false
            end,

        on_rightclick = def.on_rightclick,

        timer = 0,
        lifetimer = 600,
        env_damage_timer = 0,
        target = {player=nil, pos=nil, dist=nil},
        v_start = false,
        old_y = nil,

        set_velocity = function(self, v)
            local yaw = self.object:get_yaw()
            if self.drawtype == "side" then
                yaw = yaw+(math.pi/2)
            end
            local x = math.sin(yaw) * -v
            local z = math.cos(yaw) * v
            self.object:set_velocity({x=x, y=self.object:get_velocity().y, z=z})
        end,

        get_velocity = function(self)
            local v = self.object:get_velocity()
            return (v.x^2 + v.z^2)^(0.5)
        end,

        set_animation = function(self, type)
            if not self.animation then
                return
            end
            if not self.animation.current then
                self.animation.current = ""
            end
            if type == "stand" and self.animation.current ~= "stand" then
                if
                    self.animation.stand_start
                    and self.animation.stand_end
                    and self.animation.speed_normal
                then
                    self.object:set_animation(
                        {x=self.animation.stand_start,y=self.animation.stand_end},
                        self.animation.speed_normal, 0
                    )
                    self.animation.current = "stand"
                end
            elseif type == "walk" and self.animation.current ~= "walk"  then
                if
                    self.animation.walk_start
                    and self.animation.walk_end
                    and self.animation.speed_normal
                then
                    self.object:set_animation(
                        {x=self.animation.walk_start,y=self.animation.walk_end},
                        self.animation.speed_normal, 0
                    )
                    self.animation.current = "walk"
                end
            elseif type == "run" and self.animation.current ~= "run"  then
                if
                    self.animation.run_start
                    and self.animation.run_end
                    and self.animation.speed_run
                then
                    self.object:set_animation(
                        {x=self.animation.run_start,y=self.animation.run_end},
                        self.animation.speed_run, 0
                    )
                    self.animation.current = "run"
                end
            elseif type == "punch" and self.animation.current ~= "punch"  then
                if
                    self.animation.punch_start
                    and self.animation.punch_end
                    and self.animation.speed_normal
                then
                    self.object:set_animation(
                        {x=self.animation.punch_start,y=self.animation.punch_end},
                        self.animation.speed_normal, 0
                    )
                    self.animation.current = "punch"
                end
            end
        end,

        on_step = not disabled and function(self, dtime)
            local pos = self.object:get_pos()
            local n = minetest.get_node(pos)

            self.lifetimer = self.lifetimer - dtime
            if self.lifetimer <= 0 and not self.tamed and self.state ~= "chase" then
                local player_near = false
                for _,obj in ipairs(minetest.get_objects_inside_radius(pos, 20)) do
                    if obj:is_player() then
                        player_near = true
                        break
                    end
                end
                if not player_near then
                    mobs.barf("verbose", "Despawned", self.name, minetest.pos_to_string(pos), "end of life")
                    self.object:remove()
                    return
                end
            end

            if self.object:get_velocity().y > 0.1 then
                local yaw = self.object:get_yaw()
                if self.drawtype == "side" then
                    yaw = yaw+(math.pi/2)
                end
                local x = math.sin(yaw) * -2
                local z = math.cos(yaw) * 2
                self.object:set_acceleration({x=x, y=-10, z=z})
            else
                self.object:set_acceleration({x=0, y=-10, z=0})
            end

            if not self.disable_fall_damage and self.object:get_velocity().y == 0 then
                if self.old_y then
                    local d = self.old_y - pos.y
                    if d > 5 and minetest.get_item_group(n.name, "water") == 0 then
                        local damage = d-5
                        self.object:set_hp(self.object:get_hp()-damage)
                        if self.object:get_hp() <= 0 then
                            if self.sounds and self.sounds.death_fall then
                                minetest.sound_play(self.sounds.death_fall, {oject = self.object})
                            end
                            self:drop_litter(self.drops, pos)
                            mobs.barf("info", self.name, "fell", minetest.pos_to_string(pos), "killed")
                            self.object:remove()
                            return
                        elseif self.sounds and self.sounds.damage_fall then
                            minetest.sound_play(self.sounds.damage_fall, {oject = self.object})
                        end
                    end
                end
                self.old_y = pos.y
            end

            self.timer = self.timer+dtime
            if self.state ~= "chase" then
                if self.timer < 1 then
                    return
                end
                self.timer = 0
            end

            if self.sounds and self.sounds.random and math.random(1, 100) <= 1 then
                minetest.sound_play(self.sounds.random, {object = self.object})
            end

            self.env_damage_timer = self.env_damage_timer + dtime
            if self.env_damage_timer > 1 then
                self.env_damage_timer = 0

                if self.damage.light and self.damage.light ~= 0
                    and pos.y>0
                    and minetest.get_node_light(pos)
                    and minetest.get_node_light(pos) > 4
                    and minetest.get_timeofday() > 0.2
                    and minetest.get_timeofday() < 0.8
                then
                    self.object:set_hp(self.object:get_hp()-self.damage.light)
                    if self.object:get_hp() == 0 then
                        if self.sounds and self.sounds.death_light then
                            minetest.sound_play(self.sounds.death_light, {oject = self.object})
                        end
                        self:drop_litter(self.drops, pos)
                        mobs.barf("info", "sunburned", self.name, minetest.pos_to_string(pos), "killed")
                        self.object:remove()
                        return
                    elseif self.sounds and self.sounds.damage_light then
                        minetest.sound_play(self.sounds.damage_light, {oject = self.object})
                    end
                end

                local head_loc = {x=pos.x, y=pos.y+self.collisionbox[5], z=pos.z}
                if self.damage.water and self.damage.water ~= 0 and
                    minetest.get_item_group(minetest.get_node(head_loc).name, "water") ~= 0
                then
                    self.object:set_hp(self.object:get_hp()-self.damage.water)
                    if self.object:get_hp() == 0 then
                        if self.sounds and self.sounds.death_drown then
                            minetest.sound_play(self.sounds.death_drown, {oject = self.object})
                        end
                        self:drop_litter(self.drops, pos)
                        mobs.barf("info", self.name, "drowned", minetest.pos_to_string(pos), "killed")
                        self.object:remove()
                        return
                    elseif self.sounds and self.sounds.damage_drown then
                        minetest.sound_play(self.sounds.damage_drown, {oject = self.object})
                    end
                end

                if self.damage.lava and self.damage.lava ~= 0 and
                    minetest.get_item_group(n.name, "lava") ~= 0
                then
                    self.object:set_hp(self.object:get_hp()-self.damage.lava)
                    if self.object:get_hp() == 0 then
                        if self.sounds and self.sounds.death_lava then
                            minetest.sound_play(self.sounds.death_lava, {oject = self.object})
                        end
                        mobs.barf("info", "burned", self.name, minetest.pos_to_string(pos), "lava")
                        self.object:remove()
                        return
                    elseif self.sounds and self.sounds.damage_lava then
                        minetest.sound_play(self.sounds.damage_lava, {oject = self.object})
                    end
                end
            end

            if self.state == "chase" or self.state == "flee" then
                if not self.target.player
                    or not self.target.player:is_player()
                    or (self.follow and not self.follow(self.target.player:get_wielded_item():get_name()))
                    or (self.type == "monster" and self.target.player:get_hp() <= 0)
                then
                    self.state = "stand"
                    self.v_start = false
                    self.set_velocity(self, 0)
                    self:set_animation("stand")
                    self.target = {player=nil, pos=nil, dist=nil}
                else
                    local s = pos
                    local p = self.target.player:get_pos()
                    self.target.dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                    if self.target.dist > self.view_range then
                        self.state = "stand"
                        self.v_start = false
                        self.set_velocity(self, 0)
                        self:set_animation("stand")
                        self.target = {player=nil, pos=nil, dist=nil}
                    else
                        self.target.pos = p
                    end
                end
            end

            if self.type == "monster" and minetest.settings:get_bool("enable_damage", true) then
                for _,player in pairs(minetest.get_connected_players()) do
                    local s = pos
                    local p = player:get_pos()
                    local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                    if dist < self.view_range then
                        if not self.target.dist or self.target.dist < dist then
                            self.state = "chase"
                            self.target.player = player
                            self.target.pos = p
                            self.target.dist = dist
                        end
                    end
                end
            end

            if self.follow then
                for _,player in pairs(minetest.get_connected_players()) do
                    local s = pos
                    local p = player:get_pos()
                    local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                    if dist < self.view_range then
                        if self.follow(player:get_wielded_item():get_name()) then
                            self.state = "chase"
                            self.target.player = player
                            self.target.pos = p
                            self.target.dist = dist
                            break
                        end
                    end
                end
            end

            if self.state == "stand" then
                if math.random(1, 4) == 1 then
                    self.object:set_yaw(self.object:get_yaw()+((math.random(0,360)-180)/180*math.pi))
                end
                self.set_velocity(self, 0)
                self.set_animation(self, "stand")
                if math.random(1, 100) <= 50 then
                    self.set_velocity(self, self.walk_velocity)
                    self.state = "walk"
                    self.set_animation(self, "walk")
                end
            elseif self.state == "walk" then
                if math.random(1, 100) <= 30 then
                    self.object:set_yaw(self.object:get_yaw()+((math.random(0,360)-180)/180*math.pi))
                end
                self:try_jump()
                self.set_velocity(self, self.walk_velocity)
                self.set_animation(self, "walk")
                if math.random(1, 100) <= 10 then
                    self.set_velocity(self, 0)
                    self.state = "stand"
                    self.set_animation(self, "stand")
                end
            elseif self.state == "flee" then
                if math.random(1, 100) <= 30 then
                    self.object:set_yaw(mobs:orient(self, pos, self.target.pos)+(math.pi/4)*math.random(2,5))
                end
                self:try_jump()
                self.set_velocity(self, self.run_velocity)
                self:set_animation("run")
            elseif self.state == "chase" then
                self.object:set_yaw(mobs:orient(self, pos, self.target.pos))
                if self.target.dist > self.attack_range then
                    if not self.v_start then
                        self.v_start = true
                        self.set_velocity(self, self.run_velocity)
                        self:set_animation("run")
                    else
                        self:try_jump()
                        self.set_velocity(self, self.run_velocity)
                        self:set_animation("run")
                    end
                else
                    self.v_start = false
                    self.set_velocity(self, 0)
                    self:set_animation("stand")
                    if self:attack(self.target) then
                        self:set_animation("punch")
                        if self.sounds and self.sounds.attack then
                            minetest.sound_play(self.sounds.attack, {object = self.object})
                        end
                    end
                end
            end
        end or function (self, dtime)
            minetest.log("action", "Removed disabled "..name.." at "..minetest.pos_to_string(self.object:get_pos()))
            self.object:remove()
        end,

        on_activate = function(self, staticdata, dtime_s)
            self.object:set_armor_groups(self.armor)
            self.object:set_acceleration({x=0, y=-10, z=0})
            self.state = "stand"
            self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
            self.object:set_yaw(math.random(1, 360)/180*math.pi)
            self.lifetimer = 600 - dtime_s
            if staticdata then
                local tmp = minetest.deserialize(staticdata)
                if tmp and tmp.lifetimer then
                    self.lifetimer = tmp.lifetimer - dtime_s
                end
                if tmp and tmp.tamed then
                    self.tamed = tmp.tamed
                end
            end
            if self.lifetimer <= 0 and not self.tamed then
                mobs.barf("verbose", "Activation prevented", self.name, minetest.pos_to_string(self.object:get_pos()), "end of life" )
                self.object:remove()
            end
        end,

        get_staticdata = function(self)
            local tmp = {
                lifetimer = self.lifetimer,
                tamed = self.tamed,
            }
            return minetest.serialize(tmp)
        end,

        on_punch = function(self, hitter)
            if self.sounds and self.sounds.punch then
                minetest.sound_play(self.sounds.punch, {oject = self.object})
            end
        end,

        on_death = function(self, hitter)
            if hitter and hitter:is_player() and hitter:get_inventory() then
                if self.sounds and self.sounds.death then
                    minetest.sound_play(self.sounds.death, {oject = self.object})
                end
                mobs.barf("info", self.name, "killed", minetest.pos_to_string(self.object:get_pos()), hitter:get_player_name())
                for _,drop in ipairs(self.drops) do
                    if math.random(1, drop.chance) == 1 then
                        hitter:get_inventory():add_item("main", ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
                    end
                end
            end
        end,

        drop_litter = function(self, drops, pos)
            if minetest.settings:get_bool("mobs.drop_litter", false) then
                for _,drop in ipairs(drops) do
                    if math.random(1, drop.chance) == 1 then
                        stack = ItemStack(drop.name.." "..tostring(math.random(drop.min, drop.max)))
                        item = stack:get_definition()
                        if item and item.on_drop then
                            item.on_drop(stack, self.object, pos)
                        else
                            minetest.item_drop(stack, self.object, pos)
                        end
                    end
                end
            end
        end,
    })

    if not disabled and def.spawning_nodes then
        minetest.register_abm({
            nodenames = def.spawning_nodes,
            neighbors = {"air"},
            interval = tonumber(minetest.settings:get("mobs.interval")) or 30,
            chance = def.spawn_chance,
            action = function(pos, node, _, active_object_count_wider)
                if active_object_count_wider > def.max_spawn_count then
                    return
                end
                pos.y = pos.y+1
                if not minetest.get_node_light(pos) then
                    return
                end
                if minetest.get_node_light(pos) > def.max_spawn_light then
                    return
                end
                if minetest.get_node_light(pos) < def.min_spawn_light then
                    return
                end
                if pos.y > def.max_spawn_height then
                    return
                end
                if minetest.get_node(pos).name ~= "air" then
                    return
                end
                pos.y = pos.y+1
                if minetest.get_node(pos).name ~= "air" then
                    return
                end
                if def.spawn_func and not def.spawn_func(pos, node) then
                    return
                end
                mobs.barf("info", "Spawned", name, minetest.pos_to_string(pos), tostring(active_object_count_wider))
                minetest.add_entity(pos, name)
            end
        })
    end
end

function mobs:register_arrow(name, def)
    minetest.register_entity(name, {
        physical = false,
        visual = def.visual,
        visual_size = def.visual_size,
        textures = def.textures,
        spritediv = def.spritediv,
        initial_sprite_basepos = def.initial_sprite_basepos,
        velocity = def.velocity,
        on_activate = def.on_activate,
        hit_player = def.hit_player,
        hit_node = def.hit_node,

        on_step = function(self, dtime)
            local pos = self.object:get_pos()
            local node = minetest.get_node(pos)
            if node.name ~= "air" then
                self.hit_node(self, pos, node)
                self.object:remove()
                return
            end
            pos.y = pos.y-1
            for _,player in pairs(minetest.get_objects_inside_radius(pos, 1)) do
                if player:is_player() then
                    self.hit_player(self, player)
                    self.object:remove()
                    return
                end
            end
        end
    })
end

function mobs:orient(self, pos, target)
    local vec = {
        x = target.x-pos.x,
        y = target.y-pos.y,
        z = target.z-pos.z
    }
    local yaw = math.atan(vec.z/vec.x)
    if self.drawtype == "front" then
        yaw = yaw+(math.pi/2)
    end
    if target.x > pos.x then
        yaw = yaw+math.pi
    end
    return yaw
end

function mobs:slap(self, target, damage)
    local s = self.object:get_pos()
    local t = target:get_pos()
    if self.timer > 1 then
        local vec = {x=t.x-s.x, y=t.y-s.y, z=t.z-s.z}
        target:punch(self.object, 1.0,  {
            full_punch_interval=1.0,
            damage_groups = damage
        }, vec)
        self.timer = 0
        return true
    end
    return false
end

function mobs:shoot(name, pos, target)
    local obj = minetest.add_entity(pos, name)
    local vec = {x=target.x-pos.x, y=target.y-pos.y, z=target.z-pos.z}
    local amount = (vec.x^2+vec.y^2+vec.z^2)^0.5
    local v = obj:get_luaentity().velocity
    vec.y = vec.y+1
    vec.x = vec.x*v/amount
    vec.y = vec.y*v/amount
    vec.z = vec.z*v/amount
    obj:set_velocity(vec)
end

