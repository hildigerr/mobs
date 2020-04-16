mobs = {}

function mobs:register_mob(name, def)
    minetest.register_entity(name, {
        type = def.type,
        physical = true,
        state = "stand",
        tamed = false,

        hp_max = def.hp_max,
        armor = def.armor,
        view_range = def.view_range,
        walk_velocity = def.walk_velocity,
        run_velocity = def.run_velocity or def.walk_velocity,

        water_damage = def.water_damage,
        lava_damage = def.lava_damage,
        light_damage = def.light_damage,
        disable_fall_damage = def.disable_fall_damage,

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

        on_step = function(self, dtime)
            local pos = self.object:get_pos()
            local n = minetest.get_node(pos)
            if self.type == "monster" and minetest.settings:get_bool("mobs.only_peaceful_mobs", false) then
                self.object:remove()
                return
            end

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
                            self.drop_litter(self.drops, pos)
                            self.object:remove()
                            return
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

                if self.light_damage and self.light_damage ~= 0
                    and pos.y>0
                    and minetest.get_node_light(pos)
                    and minetest.get_node_light(pos) > 4
                    and minetest.get_timeofday() > 0.2
                    and minetest.get_timeofday() < 0.8
                then
                    self.object:set_hp(self.object:get_hp()-self.light_damage)
                    if self.object:get_hp() == 0 then
                            self.drop_litter(self.drops, pos)
                        self.object:remove()
                        return
                    end
                end

                if self.water_damage and self.water_damage ~= 0 and
                    minetest.get_item_group(n.name, "water") ~= 0
                then
                    self.object:set_hp(self.object:get_hp()-self.water_damage)
                    if self.object:get_hp() == 0 then
                        self.object:remove()
                            self.drop_litter(self.drops, pos)
                        return
                    end
                end

                if self.lava_damage and self.lava_damage ~= 0 and
                    minetest.get_item_group(n.name, "lava") ~= 0
                then
                    self.object:set_hp(self.object:get_hp()-self.lava_damage)
                    if self.object:get_hp() == 0 then
                        self.object:remove()
                        return
                    end
                end
            end

            if self.state == "chase" then
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
            elseif self.state == "chase" then
                local s = pos
                local p = self.target.pos
                local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                local yaw = math.atan(vec.z/vec.x)
                if self.drawtype == "front" then
                    yaw = yaw+(math.pi/2)
                end
                if p.x > s.x then
                    yaw = yaw+math.pi
                end
                self.object:set_yaw(yaw)
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
        end,

        on_activate = function(self, staticdata, dtime_s)
            self.object:set_armor_groups({fleshy=self.armor})
            self.object:set_acceleration({x=0, y=-10, z=0})
            self.state = "stand"
            self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
            self.object:set_yaw(math.random(1, 360)/180*math.pi)
            if self.type == "monster" and minetest.settings:get_bool("mobs.only_peaceful_mobs", false) then
                self.object:remove()
            end
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

        on_death = function(self, hitter)
            if hitter and hitter:is_player() and hitter:get_inventory() then
                for _,drop in ipairs(self.drops) do
                    if math.random(1, drop.chance) == 1 then
                        hitter:get_inventory():add_item("main", ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
                    end
                end
            end
        end,

        drop_litter = function(drops, pos)
            if minetest.settings:get_bool("mobs.drop_litter", false) then
                for _,drop in ipairs(drops) do
                    if math.random(1, drop.chance) == 1 then
                        for i=1,math.random(drop.min, drop.max) do
                            local obj = minetest.add_item(pos, drop.name)
                            if obj then
                                obj:get_luaentity().collect = true
                                local x = math.random(1, 5)
                                if math.random(1,2) == 1 then
                                    x = -x
                                end
                                local z = math.random(1, 5)
                                if math.random(1,2) == 1 then
                                    z = -z
                                end
                                obj:set_velocity({x=1/x, y=obj:get_velocity().y, z=1/z})
                            end
                        end
                    end
                end
            end
        end,

    })
end

mobs.spawning_mobs = {}
function mobs:register_spawn(name, nodes, max_light, min_light, chance, active_object_count, max_height, spawn_func)
    mobs.spawning_mobs[name] = true
    minetest.register_abm({
        nodenames = nodes,
        neighbors = {"air"},
        interval = 30,
        chance = chance,
        action = function(pos, node, _, active_object_count_wider)
            if active_object_count_wider > active_object_count then
                return
            end
            if not mobs.spawning_mobs[name] then
                return
            end
            pos.y = pos.y+1
            if not minetest.get_node_light(pos) then
                return
            end
            if minetest.get_node_light(pos) > max_light then
                return
            end
            if minetest.get_node_light(pos) < min_light then
                return
            end
            if pos.y > max_height then
                return
            end
            if minetest.get_node(pos).name ~= "air" then
                return
            end
            pos.y = pos.y+1
            if minetest.get_node(pos).name ~= "air" then
                return
            end
            if spawn_func and not spawn_func(pos, node) then
                return
            end

            if minetest.settings:get_bool("mobs.display_mob_spawn", false) then
                minetest.chat_send_all("[mobs] Spawned "..name.." at "..minetest.pos_to_string(pos))
            end
            minetest.add_entity(pos, name)
        end
    })
end

function mobs:register_arrow(name, def)
    minetest.register_entity(name, {
        physical = false,
        visual = def.visual,
        visual_size = def.visual_size,
        textures = def.textures,
        velocity = def.velocity,
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

