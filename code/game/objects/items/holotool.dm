/obj/item/holotool
	name = "experimental holotool"
	desc = "A highly experimental holographic tool projector."
	icon = 'icons/obj/objects.dmi'
	inhand_icon_state = "holotool"
	icon_state = "holotool"
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_BELT
	hitsound = 'sound/weapons/blade1.ogg'
	usesound = 'sound/items/pshoom.ogg'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	actions_types = list(/datum/action/item_action/change_tool, /datum/action/item_action/change_ht_color)
	w_class = WEIGHT_CLASS_TINY
	toolspeed = 0.55
	var/current_color = "#48D1CC" //mediumturquoise
	var/list/tools = list(
		TOOL_SCREWDRIVER = "holo-screwdriver",
		TOOL_WRENCH = "holo-wrench",
		TOOL_WIRECUTTER = "holo-wirecutters",
		TOOL_WELDER = "holo-welder",
		TOOL_CROWBAR = "holo-crowbar",
		TOOL_MULTITOOL = "holo-multitool"
	)

/obj/item/holotool/ui_action_click(mob/user, datum/action/action)
	if(istype(action, /datum/action/item_action/change_tool))
		var/chosen = input("Choose tool settings", "Tool", null, null) as null|anything in tools
		if(!chosen)
			return
		tool_behaviour = chosen
		if(tool_behaviour == TOOL_KNIFE)
			force = 10
			armour_penetration = 10
			sharpness = SHARP_EDGED
			attack_verb_simple = list("attacked", "chopped", "cleaved", "torn", "cut")
			attack_verb_continuous = list("attacked", "chopped", "cleaved", "torn", "cut")
		else
			force = 0
			armour_penetration = 10
			sharpness = NONE
			attack_verb_simple = "poked"
			attack_verb_continuous = "poked"
		playsound(loc, 'sound/items/rped.ogg', get_clamped_volume(), 1, -1)
		set_light(3, null, current_color)
	else
		var/C = input(user, "Select Color", "Select color", "#48D1CC") as null|color
		if(!C || QDELETED(src))
			return
		current_color = C
	update_appearance()
	user.regenerate_icons()

/obj/item/holotool/update_appearance()
	. = ..()
	for (var/datum/action/A in actions)
		A.UpdateButtonIcon()

/obj/item/holotool/update_icon_state()
	inhand_icon_state = tool_behaviour ? tools[tool_behaviour] : "holotool"
	return ..()

/obj/item/holotool/update_overlays()
	. = ..()
	if (tool_behaviour)
		var/mutable_appearance/holo_item = mutable_appearance(icon, tools[tool_behaviour])
		holo_item.color = current_color
		. += holo_item

/obj/item/holotool/emag_act(mob/user)
	if (!tools[TOOL_KNIFE])
		to_chat(user, "<span class='danger'>ZZT- ILLEGAL BLUEPRINT UNLOCKED- CONTACT !#$@^%$# NANOTRASEN SUPPORT-@*%$^%!</span>")
		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
		sparks.set_up(5, 0, loc)
		sparks.start()
		tools[TOOL_KNIFE] = "holo-knife"
