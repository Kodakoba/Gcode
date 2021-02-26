# ripping off bw18 like there's no tomorrow
the many issues and rules of basing can be solved with a proper base system.

## *General idea*
every building is a base; everything outside is not a base. ez.
this solves many problems:
* it doesn't require tutorializing that hacking together a building out in the streets is a bad idea (by just taking that option away, lol)
* it prevents blocking off areas of the map since you can make every prop protected only if it's in the vicinity of your base and the base has power
* it prevents basing with multiple people since you can track how many people are contesting a base
* it prevents basing in multiple bases since you can track where else the player is based
* power gridding gets quite efficient performance-wise as you offload all the boundchecking to source's physics

but we can iterate on that idea and get some new mechanics in

## *Not all bases are equal*
just due to how the map is, not all bases are created equal; some bases are out in the fuckin wilderness, making it a pain in the arse to get to. some are in some mega populated areas, where raiding gets intense and interesting just because there's not a lot of distance to cover. every base in the city part of the map (except the towers) has a buttload of rooftops and other vantage points for ambushing, scouting and defending.

without some tweaks, the most OP bases would be the ones in the wilderness due to being far away from everyone, forcing noobs into high-intensity warzones like the city apartments.

### Wat doo
* fuel reserves, where different bases have different amounts of different tiers of fuel. houses in the wild could rock a buttload of coal and gas but barely any chemical or nuclear power sources
* resource proximity, where you could make the city the part with a lot of mid-high tier inventory components vs. low-tier ores and raw materials from the outskirts ore veins
* need more...

i expect these measures to encourage noobs to go into the wilderness where they get accustomed to the gamemode, its' mechanics and get some decent gear to fight back with, where they'll eventually outgrow these places and move elsewhere for the fuel and components

## *Requirements*
* power rebalancing, where power plays a HUGE role in your defendability and progression; if you don't have enough power you should start progressing way more slowly. low risk = low reward, dumbass
* base marking: this is what i'm currently struggling with and have no idea where to even begin.

### Claiming bases
how do you claim a base?
* just putting down any entity in the base sounds lame
* generating an X amount of power to claim it sounds good; you could force people to contest a base without defenses for a while, making them fight off anyone who wants that base, as well as making them invest money into this base before they actually get it.
  however, noobs could get lost, and scaling is an issue; how do you make sure noobs can generate enough power off their shitty manual gen to claim a base? how do you tell them that they actually need to pump power into the base before it's theirs?
* base cores: am i really gonna rip off bw18 again? lol
  making base cores could allow for some extra information being pumped: you could put the fuel reserves on the base core and make that base core THE thing to destroy in a raid to quickly destroy everything else. this is basically rust TC, idk if i want that considering i fucking hate the idea of a central thing you have to defend. however it could also mean any entities which are glitched through the world or hidden would be auto-destroyed so no bullshit happens

## *Player Benefits*
of course, it wouldn't be very good if the base system didn't really bring any kind of progression for the player
* certain bases could have innate benefits assigned to them; for example, the metallurgical plant could give a bonus to every entity's durability, the bank could give a bonus to money printed, etc. making them more desirable than other bases
* as said, bases could differ in fuel reserves as well as the maximum amount of energy stored. i could make _the base_ store the power, and make each base have a reserve of excess power (for entities) and defense power (absorbs ALL damage for no energy cost out of raid and drains energy when in-raid). the cooler the base, the more power input it requires to capture but the more benefits it gives you.
* ??? something researchable?