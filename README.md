# [MOD] Simple Mobs [mobs] for MINETEST-C55 #

This mod, Forked from PilzAdam's [Simple Mobs](https://forum.minetest.net/viewtopic.php?id=3063), adds some basic hostile and friendly mobs to the game. It includes additional mobs and rotton meat, which were originally provided in another mod called [my_mobs](https://forum.minetest.net/viewtopic.php?f=11&t=4082). However my_mobs cages has not been included.

Since the [original](https://github.com/PilzAdam/mobs) mod is no longer maintained and the author of my_mobs wished to continue it's development, the two have been merged.

Upstream contributions have been included from:
 - [cnelsonsic](https://github.com/cnelsonsic)
 - [CSPS-HaydenWoods](https://github.com/CSPS-HaydenWoods)
 - [ElectricSolstice](https://github.com/ElectricSolstice)
 - [MirceaKitsune](https://github.com/MirceaKitsune)

## Settings Options ##

 - **Notify of Spawns** for debugging, *disabled* by default
 - **Drop Litter** if mobs should drop dropps when dying naturally, *disabled* by default
 - **Meat Rots** if raw meat should rot periodically, *disabled* by default
 - **Rats**, **Sheep**, and **monsters** can be drawn with a default 3D *mesh*, a 2D sprite, or be disabled.

## The Mobs ##

### Animals ###
 - [x] Cow (and milk)
 - [x] Rabbit
 - [x] Racoon
 - [x] Rat
 - [x] Sheep

### Monsters ###
 - [x] Dirt Monster
 - [x] Dungeon Master
 - [x] Oerkki
 - [x] Sand Monster
 - [x] Stone Monster
 - [x] Tree Monster

## Miscellaneous ##
 - [x] Raw and Cooked Meat
 - [ ] Meat spoilage if it remains uncooked (untested)
  -- [ ] Raw meet can be preserved through "cheating" or using a refridgerator provided
 by VanessaE's [Home Decor](https://gitlab.com/VanessaE/homedecor_modpack) Mod
 - [x] Overcooking and using the result to make dye
 - [ ] Cages for Pet Rodents (TODO: move into separate mod)
  -- They must be fed apples and have a bucket of water available to survive

## API ##
Mobs are added using the **mobs:register_mob(name, def)** function, where `name` is the name of the mob. The entity should then be referenced as `"mob:name"`. The`def` parameter is a table with all the defining attributes of the mob. For the most part, these are the same as in `minetest.register_entity()`. Other attributes are described below:

### Mob Attributes ###

 - **type** = "animal" or "monster",
 - **armor** = the armor group table which will be used by `set_armor_groups`
 - **view_range** = integer indicating how far away the mob can see a player,
 - **walk_velocity** = the velocity when the mob is walking around,
 - **run_velocity** = the velocity when the mob is running,

 - **spawning_nodes** = a table of nodes upon which the mob may spawn,
 - **max_spawn_light** = the maximum amount of light present for the mob to spawn,
 - **min_spawn_light** = the minimum amount of light present for the mob to spawn,
 - **spawn_chance** = the inverted chance for the mob to spawn per 30 second,
 - **max_spawn_count** = the maximum quantity of active mobs in the spawning node's vicinity,
 - **max_spawn_height** = the highest altitude that the mob may spawn,

 - **damage** = a table of damage per second done to the mob if it is in: **water**, **lava**, or **light**

 - **drawtype** = "front" or "side" to orient the mob's directional heading,
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

### Callbacks ###
Besides the regular [entity](https://dev.minetest.net/LuaEntitySAO) callbacks, the mobs api adds some more that you may take advantage of.

#### attack( self, target ) ####
Monsters should provide an attack method in order to inflict damage on players. The function receives two parameters, the `self` entity which is performing the attack and the `target` of the attack. The target will be a table with **player**, **pos**ition, and **dist**ance attributes. Return *true* if the attack was performed, or else *false*.

It can be as simple as using the provided **mobs:slap(self, target, damage)** function, as most of these mobs do. For example:

    attack = function(self, target)
        return mobs:slap(self, target.player, {fleshy=2})
    end

The mob entity has a a `self.timer` which should be checked to control how often the attack will take place. This is handled automatically if you use the provided `mobs:slap` method. *However, if you wish for your mob to shoot: you will need to register the projectile via `register_arrow`, and verify/update the timing yourself as is done by the Dungeon Master mob.* There is a **mobs:shoot(name, pos, target)** method provided to launch projectiles at a target. `name` is the name of the projectile, and `pos` and `target` are the *positions* of the shooter and the target respectively.

#### try_jump( self ) ####
*You don't need to provide a callback to handle mobs jumping.* However, you may. Or if you simply want to *prevent* a mob from jumping, use something like the following for your mob:

    try_jump = function(self) return end

## Issues ##
 - [ ] If you drink milk from a stack of vessels, you will not recieve the empty vessel.
 - [ ] When an entity is slain both the `on_punch` and `on_death` callbacks are triggered. So, if you have sounds for punch and death both will be heard. Take this into account while creating your sounds.

## ETHICAL DISCLOSURE ##
The sourcecode (by PilzAdam), models (by Pavel_S), and other graphics (unless otherwise noted) were originally released under the *WTFPL* (see below).

### Cow Assets ###
The cow texture was created by [rinoux](https://forum.minetest.net/memberlist.php?mode=viewprofile&u=1128). It was retrieved from the [mobf](https://wiki.minetest.net/Mods/MOB_Framework) mod by [sapier](https://forum.minetest.net/memberlist.php?mode=viewprofile&u=231). The cow's dry-up sound came from there too, which reports that the graphic is under WTFPL and the [sound](http://commons.wikimedia.org/wiki/Category:Mudchute_Park_and_Farm) was created by [Secretlondon](http://commons.wikimedia.org/wiki/User:Secretlondon).

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
