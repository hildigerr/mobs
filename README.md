# [MOD] Mobs [mobs] for MINETEST-C55 #

This mod, Forked from PilzAdam's [Simple Mobs](https://forum.minetest.net/viewtopic.php?id=3063), adds hostile and friendly mobs to the game. It includes additional mobs and rotton meat, which were originally provided in another mod called [my_mobs](https://forum.minetest.net/viewtopic.php?f=11&t=4082). However my_mobs cages has not been included.

Since the [original](https://github.com/PilzAdam/mobs) mod is no longer maintained and the author of my_mobs wished to continue it's development, the two have been merged. Development continues with these primary goals:
 - [X] Every mob should be able to be disabled through the Minetest settings interface, without disrupting a world.
 - [ ] Every mob should have both 3D mesh and 2D sprite display options.
 - [ ] Anyone should be able to add a customized mob as a drop in.

Contributions have been included from:
 - [cnelsonsic](https://github.com/cnelsonsic)
 - [CSPS-HaydenWoods](https://github.com/CSPS-HaydenWoods)
 - [ElectricSolstice](https://github.com/ElectricSolstice)
 - [MirceaKitsune](https://github.com/MirceaKitsune)
 - [Sokomine](https://github.com/Sokomine)

## Settings Options ##
For each **animal** and **monster**, there is a setting for them to be *disabled*. They will not spawn if disabled, but will still be registered in case a world already has them. Any residual mobs that are disabled will be removed once the world is loaded again. Additionally, if a mob can be drawn with a 3D *mesh* or 2D *sprite* then there is an option to select which to use.

There are also these additional setting options:
 - **Log level** primarily for debugging:
   - *disabled* by default
   - *barf* to send messages as chat broadcasts.
   - *info* to direct messages to the logfile.
   - *verbose* to send to both.
 - **Spawn Interval** will determine how often the spawning ABM is executed, *30* seconds by default
 - **Drop Litter** if mobs should drop dropps when dying naturally, *disabled* by default
 - **Rot Chance**s and **Rot Timer**s determine how often raw meat may rot. Set chances all to zero to disable. They can be set individually for:
   - **Litter**ed meat that has been dropped and is laying around,
   - **Inventory** meat that a player is carrying,
   - **Storage** meat that is stored in a container such as a chest,
   - **Cooking** meat. This may cause meat to seem to overcook, if a player starts cooking a stack of raw meat and it turns rotten before finishing.

## The Mobs ##

### Animals ###
 - [x] **Cows** are large beasts that can be milked--until they go dry. They are tasty when killed and cooked. They like grass.
 - [ ] **Chickens**
 - [x] **Donkeys** are large, stubborn beasts that can be tamed and used to carry chests. They like apples and carrots.
 - [ ] **Pigs** and **Piglets**
 - [x] **Rabbits** are cute little critters that you can pick up. They are tasty when cooked. They like berries and carrots, but are shy and get spooked easy. They can be white, grey, or brown.
 - [x] **Racoons** are cute little beasts. They will take whatever you give them, but only appreciate things that are *eatable*.
 - [x] **Rats** are cute little critters that you can pick up. They are tasty when cooked.
 - [x] **Sheep** produce wool--when well fed--that can be harvested. They are tasty when killed and cooked. They like wheat.
 - [ ] **Swans**

### Monsters ###
 - [x] Dirt Monster
 - [x] Dungeon Master
 - [x] Oerkki
 - [x] Sand Monster
 - [x] Stone Monster
 - [x] Tree Monster

### Combat Table [Spoiler Alert] ###
|Mob Name|HP/2 (Hearts)|Crumbly (Shovel)|Cracky (Pickaxe)|Choppy (Axe)|Fleshy (Sword)|
|--|--|--|--|--|--|
|Cow|9|15%|25%|80%|90%|
|Donkey|7.5|25%|25%|80%|90%|
|Rabbit|6|25%|25%|90%|100%|
|Racoon|7|25%|25%|70%|80%|
|Rat|5|100%|100%|100%|100%|
|Sheep|8|25%|25%|80%|90%|
|Dirt Monster|7|85%|50%|40%|50%|
|DM|10|1%|15%|40%|50%|
|Oerkki|9|15%|25%|50%|60%|
|Sand Monster|7|90%|30%|10%|25%|
|Stone Monster|8|1%|90%|10%|25%|
|Tree Monster|8|0%|10%|80%|70%|

## Drops ##

### Carrots ###
Carrots are included if not available from another mod. These were included in my_mobs v0.5 and supported: [TODO: re-test]
 - **food**
 - **farming_plus**
 - **docfarming**

### Meat ##
Some tasty animals can be killed for raw meat. Raw meat can become rotten if it remains uncooked. Players should also be able to preserve it using VanessaE's [Home Decor](https://gitlab.com/VanessaE/homedecor_modpack) refridgerator. [TODO: re-test]

You can purposefully overcook meat and use the result to make dye. Rotten meat cooks into *scorched stuff* as well, so it may seem like a player overcooked some meat if it becomes rotten while cooking unattended.

### TODO Ideas ###
 - [ ] AI Helper function for mob to maintain distance sans fleeing.
 - [ ] Breeding tamed animals.
 - [ ] Cheeze and eggs!
 - [X] Donkeys with burdens become chests on death.
 - [ ] Disabled donkeys become chests.
 - [ ] Extinction if overkilled.
 - [ ] Fresh meat: "fresh meat" --> "raw meat" --> "cooked meat" | ("rotten meat" --> "")
 - [ ] Grazing and unprotected garden damage.
 - [ ] Knockback
 - [ ] Limit the amount of stuff a racoon can hold.
 - [ ] Limit the quantity of donkeys as a setting, and/or kill them off every once and a while.
 - [ ] NPCs: trading, minions, armies
 - [ ] Tanning and furs for crafting.
 - [ ] Taxedermy for dropped disabled mobs or as a craft.

## API ##
Mobs are added using the **mobs:register_mob(name, def, disabled)** function, where `name` is the name of the mob. The entity should then be referenced as `"mob:name"`. The `disabled` parameter is used by all mobs to prevent spawning and to destroy any residual disabled mobs.

The`def` parameter is a table with all the defining attributes of the mob. For the most part, these are the same as in `minetest.register_entity()`. Other attributes are described below:

### Mob Attributes ###

 - **type** = "animal" or "monster",
 - **armor** = the armor group table for percentages of damage caused by:
   - **crumbly** = shovels,
   - **cracky** = pickaxes,
   - **choppy** = axes,
   - **fleshy** = swords,
 - **view_range** = integer indicating how far away the mob can see a player,
 - **walk_velocity** = the velocity when the mob is walking around,
 - **run_velocity** = the velocity when the mob is running,
 - **static** = data that should be saved for a mob instance,
 - **spawning_nodes** = a table of nodes upon which the mob may spawn,
 - **max_spawn_light** = the maximum amount of light present for the mob to spawn,
 - **min_spawn_light** = the minimum amount of light present for the mob to spawn,
 - **spawn_chance** = the inverted chance for the mob to spawn per 30 second,
 - **max_spawn_count** = the maximum quantity of active mobs in the spawning node's vicinity,
 - **max_spawn_height** = the highest altitude that the mob may spawn,

 - **damage** = a table of damage per second done to the mob if it is in: **water**, **lava**, or **light**

 - **drawtype** = "front", "side", "back", or "backside" to adjust the mob's directional heading,
 - **animation** = a table with the animation ranges and speed of a model:
   - **stand_start**
   - **stand_end**
   - **walk_start**
   - **walk_end**
   - **run_start**
   - **run_end**
   - **punch_start**
   - **punch_end**
   - **speed_normal**
   - **speed_run**

 - **sounds** = an optional table of sounds for the mob:
   - **random** = a sound that is played randomly,
   - **attack** = a sound that is played when the mob attacks,
   - **punch** = a sound that is played when the mob is hit,
   - **death_fall** = a sound that is played when a mob falls to death,
   - **death_light** = a sound that is played when a mob dies in light,
   - **death_lava** = a sound that is played when a mob dies in lava,

 - **drops** = a list of tables indicating what the mob drops when dying:
   - **name** = itemname,
   - **chance** = the inverted chance to get the item,
   - **min** = the minimum quantity of items,
   - **max** = the maximum quantity of items,

### States ###
Mobs start out in the **stand**ing state. They will then start **walk**ing around randomly, ocasionally stopping to *stand* around again. If a `monster` type notices a player--and damage is enabled--the mob will give **chase**! If the player is holding something that a mob likes to follow, it will do so in the *chase* state. Once in range, mobs in the *chase* state will attack (if they have an attack). There is also a **flee** state in which mobs will run away from a target. When the target a mob is attacking or fleeing from dies, or otherwise is out of view, they will stop and *stand* again. If a player stops wielding an item that a mob follows, then it will stop *chase*ing--unless, of course, it still wants to attack.

### Callbacks ###
Besides the regular [entity](https://dev.minetest.net/LuaEntitySAO) callbacks, the mobs api adds some more that you may take advantage of. Additionally, there are helper functions availabe for assisting in the implementation of these callbacks.

#### after_activate( self, dtime_s) ####
When a mob is activated, it's **static** data is loaded. The `after_activate` callback will then be executed if provided. The `dtime_s` parameter is the time passed since the entity was unloaded, as passed throgh the `on_activate` function.

#### attack( self, target ) ####
Monsters should provide an attack method in order to inflict damage on players. The function receives two parameters, the `self` entity which is performing the attack and the `target` of the attack. The target will be a table with **player**, **pos**ition, and **dist**ance attributes. Return *true* if the attack was performed, or else *false*.

The mob entity has a a `self.timer` which should be checked to control how often the attack will take place. This is handled automatically if you use the provided `mobs:slap` method. *However, if you wish for your mob to shoot: you will need to register the projectile via `mobs:register_arrow`, and verify/update the timing yourself as is done by the Dungeon Master mob.*

#### follow( item ) ####
The mob's optional `follow` callback is used to check if a player is wielding something the mob likes. The input `item` will be the wielded item's name. The function should return `true` if the mob is attracted to the item.

#### on_death( self, hitter ) ####
Mobs has it's own `on_death` callback, however a mob may supply one of it's own which will be executed first.

#### try_jump( self ) ####
*You don't need to provide a callback to handle mobs jumping.* However, you may. Or if you simply want to *prevent* a mob from jumping, use something like the following for your mob:

    try_jump = function(self) return end

#### Helper Functions ####

##### mobs:orient(self, pos, target) #####
Returns a heading, in radians, which can be used with `set_yaw` to orient `self` in the direction from `pos` to `target`.

##### mobs:register_arrow(name, def) #####
Projectiles can be registered with this function, and then be launched using the `mobs:shoot` function. They are referened by `name` such as the Dungeon Master's `mobs:fireball`. The `def`inition is a table with attributes with the following values:

 - `visual` = "cube" or "sprite" or "upright_sprite", [TODO: "mesh"]
 - `visual_size` = {x,y},
 - `textures` = a table of textures, the quantity of which depend on *visual*,
 - `velocity` = the speed with which the projectile witll travel on its trajectory,
 - `hit_player` = a callback function(self, player) to be called when the projectile hits a player,
 - `hit_node` = a callback function(self, pos, node) to be called when the projectile hits a node

##### mobs:slap(self, target, damage) #####
Punch the `target` with `damage` damage groups for use as an `attack` callback. This is what most mobs use. For example:

    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=2})
    end

##### mobs:shoot(name, pos, target) #####
Launch projectiles at a target. `name` is the name of the projectile. `pos` and `target` are the *positions* of the shooter and the target respectively.

## Issues ##
 - [ ] When an entity is slain both the `on_punch` and `on_death` callbacks are triggered. So, if you have sounds for punch and death both will be heard. Take this into account while creating your sounds.

## ETHICAL DISCLOSURE ##
The sourcecode (by PilzAdam), models (by Pavel_S), and other graphics (unless otherwise noted) were originally released under the *WTFPL* (see below).

### Cow Assets ###
The 2D cow texture was created by [rinoux](https://forum.minetest.net/memberlist.php?mode=viewprofile&u=1128). It was retrieved from the [mobf](https://wiki.minetest.net/Mods/MOB_Framework) mod by [sapier](https://forum.minetest.net/memberlist.php?mode=viewprofile&u=231). The cow's dry-up sound came from there too, which reports that the graphic is under WTFPL and the [sound](http://commons.wikimedia.org/wiki/Category:Mudchute_Park_and_Farm) was created by [Secretlondon](http://commons.wikimedia.org/wiki/User:Secretlondon). The milk_[splash](http://www.youtube.com/watch?v=Z3GEcgwEMQo) sound effect, for when milking a cow, was originally added in my_mobs v0.2.

### Racoon Assets ###
The racoon was originally added in my_mobs v0.5. All that is know of the 2D sprite is that the original --[link](http://stephaniecome-ryker.com/blog/wp-content/uploads/2011/04/coon.jpg)-- is broken.

### Rodent Assets ###
The rabbit and rat textures were acquired from cornernote's [critters](http://minetest.net/forum/viewtopic.php?id=3337) modpack. It's README.txt reports:

    Artist: Martin Berube (Available for custom work)
    Iconset Homepage: [http://www.graphics-and-desktop-icons.com/animal-icons.html](http://www.graphics-and-desktop-icons.com/animal-icons.html)
    License: Freeware
    Commercial usage: Allowed
    Readme file: textures/terms-of-use.txt (see below)

The current rat-in-cage image is also adapted from one of the critters from the same source as the rabbit.

#### Rodent Terms-of-use.txt ####
    Terms of use

    1. Terms
    By accessing this folder, you are agreeing to be bound by these folder Terms and Conditions of Use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this folder. The materials contained in this folder are protected by applicable copyright and trade mark law.

    2. Use License

    General use of the icons:

    Permission is granted to temporarily download one copy of the materials (icons) on Graphics-and-desktop-icons.com for personal or commercial use. This is the grant of a license, not a transfer of title, and under this license you may not:
    - claim to be the author of the images;
    - sell the images (clipart resale);
    - transfer the materials to another person or "mirror" the materials on any other server unless a static link is provide to Graphics-and-desktop-icons.com's homepage.
    This license shall automatically terminate if you violate any of these restrictions and may be terminated by Graphics-and-desktop-icons.com at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.

    Services:

    The materials provided through services by Graphics-and-desktop-icons.com or its owner are provided "as is". Graphics-and-desktop-icons.com and its owner makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, Graphics-and-desktop-icons.com and its owner does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials provided by Graphics-and-desktop-icons.com and its owner or otherwise relating to such materials.

    In no event shall Graphics-and-desktop-icons.com, its owner or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials provided by Graphics-and-desktop-icons.com or its owner, even if Graphics-and-desktop-icons.com or its owner has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.

    Any claim relating to Graphics-and-desktop-icons.com or its owner shall be governed by the laws of the State of Graphics-and-desktop-icons.com or its owner without regard to its conflict of law provisions.

    3. Disclaimer
    The materials on Graphics-and-desktop-icons.com are provided "as is". Graphics-and-desktop-icons.com makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, Graphics-and-desktop-icons.com does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its Internet web site or otherwise relating to such materials or on any sites linked to this site.

    4. Limitations
    In no event shall Graphics-and-desktop-icons.com or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials on Graphics-and-desktop-icons.com Internet site, even if Graphics-and-desktop-icons.com or a Graphics-and-desktop-icons.com authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.

    5. Revisions and Errata
    The materials appearing on Graphics-and-desktop-icons.com could include technical, typographical, or photographic errors. Graphics-and-desktop-icons.com does not warrant that any of the materials on its web site are accurate, complete, or current. Graphics-and-desktop-icons.com may make changes to the materials contained on its web site at any time without notice.

    6. Links
    Graphics-and-desktop-icons.com has not reviewed all of the sites linked to its Internet web site and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Graphics-and-desktop-icons.com of the site. Use of any such linked web site is at the user's own risk.

    7. Site Terms of Use Modifications
    Graphics-and-desktop-icons.com may revise these terms of use for its web site at any time without notice. By using this web site you are agreeing to be bound by the then current version of these Terms and Conditions of Use.

    8. Governing Law
    Any claim relating to Graphics-and-desktop-icons.com shall be governed by the laws of the State of Graphics-and-desktop-icons.com without regard to its conflict of law provisions.

## Sound Assets ##
The rest of the sounds were found at various locations that I don't recall, unless otherwise acknowledged in changes.txt. If you own one of them, I will remove it and delete all copies of it, at you're request.

## Other Assets ##
The unused images were created by me using [THE GIMP](http://www.gimp.org/)

## WTFPL ##

             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                        Version 2, December 2004

     Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

     Everyone is permitted to copy and distribute verbatim or modified
     copies of this license document, and changing it is allowed as long
     as the name is changed.

                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
       TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

      0. You just DO WHAT THE FUCK YOU WANT TO.
