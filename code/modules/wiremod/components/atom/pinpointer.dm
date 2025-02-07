/**
 * # Proximity Pinpointer Component
 *
 * Return the location of its input.
 */
/obj/item/circuit_component/pinpointer
	display_name = "Proximity Pinpointer"
	display_desc = "A component that returns the xyz co-ordinates of its entity input, as long as its in view."

	var/datum/port/input/target

	var/datum/port/output/x_pos
	var/datum/port/output/y_pos
	var/datum/port/output/z_pos

	var/datum/port/output/on_error

	var/max_range = 20

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/pinpointer/get_ui_notices()
	. = ..()
	. += create_ui_notice("Maximum Range: [max_range] tiles", "orange", "info")

/obj/item/circuit_component/pinpointer/Initialize()
	. = ..()
	target = add_input_port("Target entity", PORT_TYPE_ATOM, FALSE)

	x_pos = add_output_port("X", PORT_TYPE_NUMBER)
	y_pos = add_output_port("Y", PORT_TYPE_NUMBER)
	z_pos = add_output_port("Z", PORT_TYPE_NUMBER)
	on_error = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/pinpointer/Destroy()
	target = null
	return ..()

/obj/item/circuit_component/pinpointer/input_received(datum/port/input/port)
	. = ..()
	if(.)
		return

	var/atom/object = target.input_value

	var/turf/location = get_turf(object)

	if(object.z != location.z || get_dist(location, object) > max_range || !object)
		x_pos.set_output(null)
		y_pos.set_output(null)
		z_pos.set_output(null)
		on_error.set_output(COMPONENT_SIGNAL)

	else
		x_pos.set_output(location?.x)
		y_pos.set_output(location?.y)
		z_pos.set_output(location?.z)

