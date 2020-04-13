mobs = {}
function mobs:register_mob(name, def)
    minetest.register_entity(name, {
        type = def.type,
        physical = true,
        state = "stand",
        tamed = false,

        hp_max = def.hp_max,
        damage = def.damage,
        armor = def.armor,
        view_range = def.view_range,
        walk_velocity = def.walk_velocity,
        run_velocity = def.run_velocity,

        water_damage = def.water_damage,
        lava_damage = def.lava_damage,
        light_damage = def.light_damage,
        disable_fall_damage = def.disable_fall_damage,

        visual = def.visual,
        drawtype = def.drawtype,
        visual_size = def.visual_size,
        collisionbox = def.collisionbox,
        textures = def.textures,

        sounds = def.sounds,
        makes_footstep_sound = def.makes_footstep_sound,
        follow = def.follow,

        drops = def.drops,

        attack_type = def.attack_type,
        arrow = def.arrow,
        shoot_interval = def.shoot_interval,

        on_rightclick = def.on_rightclick,

        timer = 0,
        lifetimer = 600,
        env_damage_timer = 0,
        target = {player=nil, dist=nil},
        v_start = false,
        old_y = nil,

        set_velocity = function(self, v)
            local yaw = self.object:getyaw()
            if self.drawtype == "side" then
                yaw = yaw+(math.pi/2)
            end
            local x = math.sin(yaw) * -v
            local z = math.cos(yaw) * v
            self.object:setvelocity({x=x, y=self.object:getvelocity().y, z=z})
        end,

        get_velocity = function(self)
            local v = self.object:getvelocity()
            return (v.x^2 + v.z^2)^(0.5)
        end,

        on_step = function(self, dtime)
            local pos = self.object:getpos()
            local n = minetest.env:get_node(pos)
            if self.type == "monster" and minetest.setting_getbool("only_peaceful_mobs") then
                self.object:remove()
            end

            self.lifetimer = self.lifetimer - dtime
            if self.lifetimer <= 0 and not self.tamed and self.state ~= "attack" then
                local player_near = false
                for _,obj in ipairs(minetest.env:get_objects_inside_radius(pos, 20)) do
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

            if self.object:getvelocity().y > 0.1 then
                local yaw = self.object:getyaw()
                if self.drawtype == "side" then
                    yaw = yaw+(math.pi/2)
                end
                local x = math.sin(yaw) * -2
                local z = math.cos(yaw) * 2
                self.object:setacceleration({x=x, y=-10, z=z})
            else
                self.object:setacceleration({x=0, y=-10, z=0})
            end

            if not self.disable_fall_damage and self.object:getvelocity().y == 0 then
                if self.old_y then
                    local d = self.old_y - pos.y
                    if d > 5 and minetest.get_item_group(n.name, "water") == 0 then
                        local damage = d-5
                        self.object:set_hp(self.object:get_hp()-damage)
                        if self.object:get_hp() <= 0 then
                            self.object:remove()
                            return
                        end
                    end
                end
                self.old_y = pos.y
            end

            self.timer = self.timer+dtime
            if self.state ~= "attack" then
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
                    and minetest.env:get_node_light(pos)
                    and minetest.env:get_node_light(pos) > 4
                    and minetest.env:get_timeofday() > 0.2
                    and minetest.env:get_timeofday() < 0.8
                then
                    self.object:set_hp(self.object:get_hp()-self.light_damage)
                    if self.object:get_hp() == 0 then
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

            if self.type == "monster" and minetest.setting_getbool("enable_damage") then
                for _,player in pairs(minetest.get_connected_players()) do
                    local s = pos
                    local p = player:getpos()
                    local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                    if dist < self.view_range then
                        if not self.target.dist or self.target.dist < dist then
                            self.state = "attack"
                            self.target.player = player
                            self.target.dist = dist
                        end
                    end
                end
            end

            if self.follow then
                for _,player in pairs(minetest.get_connected_players()) do
                    local s = pos
                    local p = player:getpos()
                    local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                    if dist < self.view_range then
                        if player:get_wielded_item():get_name() == self.follow then
                            self.following = player
                            break
                        end
                    end
                end

                if not self.following
                    or not self.following:is_player()
                    or self.following:get_wielded_item():get_name() ~= self.follow
                then
                    self.following = nil
                    self.state = "stand"
                    self.v_start = false
                    self.set_velocity(self, 0)
                else
                    local s = pos
                    local p = self.following:getpos()
                    local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                    if dist > self.view_range then
                        self.following = nil
                        self.state = "stand"
                        self.v_start = false
                        self.set_velocity(self, 0)
                    else
                        local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                        local yaw = math.atan(vec.z/vec.x)+math.pi/2
                        if self.drawtype == "side" then
                            yaw = yaw+(math.pi/2)
                        end
                        if p.x > s.x then
                            yaw = yaw+math.pi
                        end
                        self.object:setyaw(yaw)
                        if dist > 2 then
                            if not self.v_start then
                                self.v_start = true
                                self.set_velocity(self, -self.run_velocity)
                            else
                                if self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
                                    local v = self.object:getvelocity()
                                    v.y = 5
                                    self.object:setvelocity(v)
                                end
                                self.set_velocity(self, -self.run_velocity)
                            end
                        else
                            self.v_start = false
                            self.set_velocity(self, 0)
                        end
                        return
                    end
                end
            end

            if self.state == "stand" then
                if math.random(1, 4) == 1 then
                    self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                end
                self.set_velocity(self, 0)
                if math.random(1, 100) <= 50 then
                    self.set_velocity(self, self.walk_velocity)
                    self.state = "walk"
                end
            elseif self.state == "walk" then
                if math.random(1, 100) <= 30 then
                    self.object:setyaw(self.object:getyaw()+((math.random(0,360)-180)/180*math.pi))
                end
                if self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
                    local v = self.object:getvelocity()
                    v.y = 5
                    self.object:setvelocity(v)
                end
                self.set_velocity(self, self.walk_velocity)
                if math.random(1, 100) <= 10 then
                    self.set_velocity(self, 0)
                    self.state = "stand"
                end
            elseif self.state == "attack" then
                if not self.target.player or not self.target.player:is_player() then
                    self.state = "stand"
                    return
                end
                local s = pos
                local p = self.target.player:getpos()
                local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5
                if dist > self.view_range or self.target.player:get_hp() <= 0 then
                    self.state = "stand"
                    self.v_start = false
                    self.set_velocity(self, 0)
                    self.target = {player=nil, dist=nil}
                    return
                else
                    self.target.dist = dist
                end

                local vec = {x=p.x-s.x, y=p.y-s.y, z=p.z-s.z}
                local yaw = math.atan(vec.z/vec.x)+math.pi/2
                if self.drawtype == "side" then
                    yaw = yaw+(math.pi/2)
                end
                if p.x > s.x then
                    yaw = yaw+math.pi
                end
                self.object:setyaw(yaw)
                if self.attack_type == "dogfight" then
                    if self.target.dist > 2 then
                        if not self.v_start then
                            self.v_start = true
                            self.set_velocity(self, self.run_velocity)
                        else
                            if self.get_velocity(self) <= 0.5 and self.object:getvelocity().y == 0 then
                                local v = self.object:getvelocity()
                                v.y = 5
                                self.object:setvelocity(v)
                            end
                            self.set_velocity(self, self.run_velocity)
                        end
                    else
                        self.v_start = false
                        self.set_velocity(self, 0)
                        if self.timer > 1 then
                            self.timer = 0
                            if self.sounds and self.sounds.attack then
                                minetest.sound_play(self.sounds.attack, {object = self.object})
                            end
                            self.target.player:punch(self.object, 1.0,  {
                                full_punch_interval=1.0,
                                damage_groups = {fleshy=self.damage}
                            }, vec)
                        end
                    end
                elseif self.attack_type == "shoot" then
                    self.set_velocity(self, 0)

                    if self.timer > self.shoot_interval and math.random(1, 100) <= 60 then
                        self.timer = 0

                        if self.sounds and self.sounds.attack then
                            minetest.sound_play(self.sounds.attack, {object = self.object})
                        end

                        local obj = minetest.env:add_entity(pos, self.arrow)
                        local amount = (vec.x^2+vec.y^2+vec.z^2)^0.5
                        local v = obj:get_luaentity().velocity
                        vec.y = vec.y+1
                        vec.x = vec.x*v/amount
                        vec.y = vec.y*v/amount
                        vec.z = vec.z*v/amount
                        obj:setvelocity(vec)
                    end
                end
            end
        end,

        on_activate = function(self, staticdata, dtime_s)
            self.object:set_armor_groups({fleshy=self.armor})
            self.object:setacceleration({x=0, y=-10, z=0})
            self.state = "stand"
            self.object:setvelocity({x=0, y=self.object:getvelocity().y, z=0})
            self.object:setyaw(math.random(1, 360)/180*math.pi)
            if self.type == "monster" and minetest.setting_getbool("only_peaceful_mobs") then
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

        on_punch = function(self, hitter)
            if self.object:get_hp() <= 0 then
                if hitter and hitter:is_player() and hitter:get_inventory() then
                    for _,drop in ipairs(self.drops) do
                        if math.random(1, drop.chance) == 1 then
                            hitter:get_inventory():add_item("main", ItemStack(drop.name.." "..math.random(drop.min, drop.max)))
                        end
                    end
                end
            end
        end,

    })
end

mobs.spawning_mobs = {}
function mobs:register_spawn(name, nodes, max_light, min_light, chance, active_object_count, max_height)
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
            if not minetest.env:get_node_light(pos) then
                return
            end
            if minetest.env:get_node_light(pos) > max_light then
                return
            end
            if minetest.env:get_node_light(pos) < min_light then
                return
            end
            if pos.y > max_height then
                return
            end
            if minetest.env:get_node(pos).name ~= "air" then
                return
            end
            pos.y = pos.y+1
            if minetest.env:get_node(pos).name ~= "air" then
                return
            end

            if minetest.setting_getbool("display_mob_spawn") then
                minetest.chat_send_all("[mobs] Add "..name.." at "..minetest.pos_to_string(pos))
            end
            minetest.env:add_entity(pos, name)
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
            local pos = self.object:getpos()
            if minetest.env:get_node(pos).name ~= "air" then
                self.hit_node(self, pos, node)
                self.object:remove()
                return
            end
            pos.y = pos.y-1
            for _,player in pairs(minetest.env:get_objects_inside_radius(pos, 1)) do
                if player:is_player() then
                    self.hit_player(self, player)
                    self.object:remove()
                    return
                end
            end
        end
    })
end
