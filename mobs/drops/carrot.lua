if minetest.get_modpath("food") ~= nil then
    minetest.register_alias("mobs:carrot", "food:carrot")
elseif minetest.get_modpath("farming_plus") ~= nil then
    minetest.register_alias("mobs:carrot", "farming_plus:carrot_item")
elseif minetest.get_modpath("docfarming") ~= nil then
    minetest.register_alias("mobs:carrot", "docfarming:carrot")
else
    minetest.register_craftitem("mobs:carrot", {
        description = "Carrot",
        inventory_image = "mobs_carrot.png",
        on_use = minetest.item_eat(4),
    })
end
