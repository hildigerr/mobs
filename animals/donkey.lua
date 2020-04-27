local donkey_setting = minetest.settings:get("mobs.donkeys") or "mesh"

minetest.create_detached_inventory("donkey")
donkey_bags = {
    inventory = minetest.get_inventory({type="detached", name="donkey"}),
    listing = {},
    freelist = {},
    chars = {48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70},
    add = function(bag)
        local dname = table.remove(donkey_bags.freelist)
        while not dname or donkey_bags.listing[dname] do
            dname = "dkbg-"
            for i = 1, 8 do
                dname = dname..string.char(donkey_bags.chars[math.random(1,16)])
            end
        end
        mobs:barf("info", "donkey_bag added", "detached", dname)
        donkey_bags.inventory:set_size(dname, 8*4)
        local content = {}
        for i,each in ipairs(bag) do
            content[i] = ItemStack(each)
        end
        donkey_bags.inventory:set_list(dname, content)
        donkey_bags.listing[dname] = bag
        return dname
    end
}

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local bagID, found = string.gsub(formname, "mobs:", "")
    if found > 0 then
        local bag = donkey_bags.inventory:get_list(bagID)
        local store = donkey_bags.listing[bagID]
        for each,item in ipairs(bag) do
            store[each] = item:to_string()
        end
    end
end)

mobs:register_mob("donkey", {
    type = "animal",

    hp_max = 15,
    armor = {crumbly = 25, cracky = 25, choppy = 80, fleshy = 90},
    walk_velocity = 1,

    spawning_nodes = {"default:dirt_with_grass", "default:stone"},
    max_spawn_light = 20,
    min_spawn_light = -1,
    spawn_chance = 7000,
    max_spawn_count = 1,
    max_spawn_height = 31000,

    damage = {water = 5, lava = 8, light = 0},

    visual = "mesh",
    drawtype = "backside",
    mesh = "mobs_donkey.x",
    visual_size = {x=2.0, y=2.5},
    collisionbox = {-0.7, -0.01, -0.4, 0.7, 1.4, 0.4},
    textures = {"mobs_donkey_mesh.png"},
    animation = {
        speed_normal = 15,
        stand_start = 1,
        stand_end = 40,
        walk_start = 40,
        walk_end = 60,
        run_start = 45,
        run_end = 85,
    },

-- frames:
--     1-40 standing (without backpack), 45-85 running (without backpack),
--     90-130 standing (empty backpack), 135-175 running (empty backpack),
--     180-220 standing (full backpack), 225-265 running (full backpack)

    makes_footstep_sound = false,

    drops = {},

    static_default = { bag = nil },

    after_activate = function(self, dtime_s)
        if self.tamed then
            if self.static.owner then
                self.object:set_nametag_attributes({text = self.static.owner.."'s donkey"})
            end
            if self.static.bag then
                if not self.static.bagID or not donkey_bags.listing[self.static.bagID] then
                    self.static.bagID = donkey_bags.add(self.static.bag)
                end
            end
            self.animation = not self.static.bag and
                 {
                    speed_normal = 15,
                    stand_start = 90,
                    stand_end = 130,
                    walk_start = 135,
                    walk_end = 175,
                }
            or
                {
                    speed_normal = 15,
                    stand_start = 180,
                    stand_end = 220,
                    walk_start = 225,
                    walk_end = 265,
                }
        end
    end,

    on_death = function(self, hitter)
        if self.static.bag then
            local pos = self.object:get_pos()
            minetest.add_node(pos, {name = "default:chest"})
            local content = {}
            for i,each in ipairs(self.static.bag) do
                content[i] = ItemStack(each)
            end
            local inventory = minetest.get_inventory({type="node", pos=pos})
            inventory:set_list("main", content)
            table.insert(donkey_bags.freelist, self.static.bagID)
            donkey_bags.listing[self.static.bagID] = false
        end
    end,

    on_rightclick = function(self, clicker)
        local open_donkey_chest = function(self, clicker)
            minetest.sound_play("default_chest_open", {gain = 0.3,
            pos = self.object:get_pos(), max_hear_distance = 10}, true)
            minetest.after(0.2, minetest.show_formspec, clicker:get_player_name(),
                "mobs:"..self.static.bagID, 
                "size[8,9;]" ..
                "list[detached:donkey;"..self.static.bagID..";0,0;8,4;]" ..
                "list[current_player;main;0,5;8,4;]"
            )
        end
        local item = clicker:get_wielded_item()
        local item_name = item:get_name()
        if item_name == "mobs:carrot" or item_name == "default:apple" then
            item:take_item()
            self.static.stubbornness = (self.static.stubbornness or math.random(8,20)) - 1
            if self.static.stubbornness <= 0 then
                self.tamed = true
            end
        elseif self.tamed then
            if self.static.owner then
                if self.static.owner == clicker:get_player_name() then
                    open_donkey_chest(self, clicker)
                    return
                end
            else
                if not self.static.bag then
                    if item_name == "default:chest_locked" then
                        item:take_item()
                        self.static.owner = clicker:get_player_name()
                        self.static.bag = {}
                    elseif item_name == "default:chest" then
                        item:take_item()
                        self.static.bag = {}
                    end
                else
                    if item_name == "default:chest_locked" and donkey_bags.inventory:is_empty(self.static.bagID) then
                        item:take_item()
                        clicker:set_wielded_item(item)
                        self.static.owner = clicker:get_player_name()
                        item = ItemStack("default:chest")
                    else
                        open_donkey_chest(self, clicker)
                        return
                    end
                end
            end
        end
        clicker:set_wielded_item(item)
        self.after_activate(self, 0)
    end,
}, donkey_setting == "disabled")
