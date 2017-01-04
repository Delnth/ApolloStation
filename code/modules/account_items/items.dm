///////This file is just for account items, not donator items. Event rewards and such can be added here.


/////ID
/obj/item/weapon/card/id/fluff/lifetime
	name = "Lifetime ID Card"
	desc = "A modified ID card given only to those people who have devoted their lives to the better interests of NanoTrasen."
	icon_state = "centcom_old"

/datum/gear/account/lifetime_id
	display_name = "Lifetime ID Card"
	path = /obj/item/weapon/card/id/fluff/lifetime
	sort_category = "ID_card"
/////End ID
/////Gold Zippo (sprite credit to Linker)
/obj/item/weapon/flame/lighter/zippo/fluff/golden
	name = "golden zippo lighter"
	desc = "A golden zippo lighter gifted to some crew members by Central Command operatives"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "zippo_gold_linker"
	icon_on = "zippoon_gold_linker"
	icon_off = "zippo_gold_linker"
	
/datum/gear/account/goldzippo
	display_name = "Gold Zippo Lighter"
	path = /obj/item/weapon/flame/lighter/zippo/fluff/golden
	sort_category = "misc"
/////End gold zippo
/////Gold Medal (Only needs Datum)
/datum/gear/account/goldmedalreward
	display_name = "Gold Heroism Medal"
	path = /obj/item/clothing/tie/medal/gold/heroism
	sort_category = "misc"
/////End Medal

////////////////////////////////// Koenigsegg /////////////////////////////////////////////////

// Noot Noot Racecar test
/datum/gear/account/delta
	display_name = "Delta"
	path = /mob/living/simple_animal/dog/german_shep/fluff/delta
	sort_category = "misc"

/obj/item/weapon/holder/delta
	name = "Delta"
	desc = "This is Delta the dog."
	icon = 'icons/obj/objects.dmi'
	icon_state = "german_shep"
	origin_tech = null

/obj/item/weapon/holder/delta/New()
	..()
	var/mob/doggy = new /mob/living/simple_animal/dog/german_shep/fluff/delta()
	doggy.loc = src

/mob/living/simple_animal/dog/german_shep/fluff/delta
	name = "Delta"
	desc = "This big puppy has thick, black and yellow fur."
	gender = MALE
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	health = 50
	maxHealth = 50
	var/max_distance = 4
	var/mob/living/carbon/human/bff
	var/turf/bff_last_loc
	var/turf/target_loc

/mob/living/simple_animal/dog/german_shep/fluff/delta/New()
	..()
	for( var/mob/living/carbon/human/M in living_mob_list )
		if (M.mind)
			if (M.mind.key == "Koenigsegg")
				bff = M
				break

/mob/living/simple_animal/dog/german_shep/fluff/delta/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()
	audible_emote("[pick("whimpers", "snarls", "yaps")] at [user]!")

/mob/living/simple_animal/dog/german_shep/fluff/delta/Life()
	..()
	if(client || stat)
		return

	if(!resting && !buckled)
		handle_movement_target()

	if (target_loc)
		return

	if (get_dist(src, bff) <= 1)
		if (prob(2))
			visible_emote(pick("sniffs [bff].", "nudges [bff]."))
			return

	if (get_dist(src, bff) <= max_distance)
		if (bff.stat >= DEAD || bff.health <= config.health_threshold_softcrit)
			if (prob((bff.stat < DEAD)? 50 : 15))
				audible_emote(pick("let out a [pick("lonely", "sad", "long", "agonizing")] howl.",
								   "howls.",
								   "whimpers.",
								   "whines."))
				return
		else if (bff.health <= 50)
			if (prob(10))
				audible_emote(pick("let out a [pick("low", "long", "short")] growl.", "growls.", "barks."))
				return
		else if (prob(1))
			audible_emote("barks at [bff].")
			return

	if (prob(2))
		visible_emote(pick("sniffs the air.", "wags his tail."))
	else if (prob(2))
		audible_emote(pick("pants.",
						   "sighs.",
						   "yawns."))
	else
		for(var/mob/living/simple_animal/ani in oview(src,5))
			if(ani.stat < DEAD && prob(5))
				audible_emote("[pick("barks", "whines")] at [ani].")
			break

/mob/living/simple_animal/dog/german_shep/fluff/delta/proc/handle_movement_target()
	var/can_see_bff = 0
	if (bff)
		if (bff in oview(src))
			can_see_bff = 1
			bff_last_loc = bff.loc

	var/follow_dist = max_distance
	if (bff.stat >= DEAD || bff.health <= config.health_threshold_softcrit || !(can_see_bff))
		follow_dist = 1
	else if (bff.stat || bff.health <= 50) //danger or just sleeping
		follow_dist = 2

	if (target_loc != bff.loc && (get_dist(src, bff) > follow_dist || !(can_see_bff)))
		if (can_see_bff)
			target_loc = bff.loc
		else if (bff_last_loc)
			target_loc = bff_last_loc
			bff_last_loc = null
		if (target_loc)
			walk_to(src,0) // stop existing movement
			stop_automated_movement = 1
			walk_to(src,target_loc,1,3)	// begin to walk now

	if (target_loc && get_dist(src, target_loc) <= 1)
		walk_to(src,0)
		target_loc = null
		stop_automated_movement = 0
