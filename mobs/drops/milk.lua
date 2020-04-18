
minetest.register_craftitem("mobs:milk_bucket", {
    description = "Bucket of Milk",
    image = "mobs_bucket_milk.png",
    on_use = minetest.item_eat(8,"bucket:bucket_empty"),
    groups = { eatable=1 },
    stack_max = 1,
})

minetest.register_craftitem("mobs:milk_bottle_glass", {
    description = "Bottle of Milk",
    image = "mobs_glass_bottle_milk.png",
    wield_image = "mobs_glass_bottle_milk_wield.png",
    on_use = minetest.item_eat(4, "vessels:glass_bottle"),
    groups = { eatable=1 },
})

minetest.register_craftitem("mobs:milk_glass_cup", {
    description = "Bottle of Milk",
    image = "mobs_drinking_glass_milk.png",
    wield_image = "mobs_drinking_glass_milk_wield.png",
    on_use = minetest.item_eat(2, "vessels:drinking_glass"),
    groups = { eatable=1 },
})

minetest.register_craftitem("mobs:milk_bottle_steel", {
    description = "Flask of Milk",
    image = --"vessels_steel_bottle.png",
        "mobs_steel_bottle_milk.png",
    on_use = minetest.item_eat(4, "vessels:steel_bottle"),
    groups = { eatable=1 },
})
