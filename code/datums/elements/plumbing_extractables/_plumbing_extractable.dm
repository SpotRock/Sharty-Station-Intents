///Element used for interfacing with the plumbing people extractor machine. Placed on the reagents datum
/datum/element/plumbing_extractable
	var/list/required_reagents = list(/datum/reagent/water = 2)
	var/list/returned_reagents = list(/datum/reagent/consumable/lemonade = 1)

	element_flags = ELEMENT_DETACH

/datum/element/plumbing_extractable/Attach(datum/target)
	. = ..()
	if(!istype(target, /datum/reagents))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, list(COMSIG_MOB_EXTRACT_MILK), .proc/try_trade)

/datum/element/plumbing_extractable/Detach(datum/target)
	UnregisterSignal(target, COMSIG_MOB_EXTRACT_MILK)
	return ..()

///Check if all required reagents are present
/datum/element/plumbing_extractable/proc/has_required(datum/reagents/victim)
	for(var/A in required_reagents)
		if(!victim.has_reagent(A, required_reagents[A]))
			return FALSE
	return TRUE

///Remove the required reagents
/datum/element/plumbing_extractable/proc/take_required(datum/reagents/victim)
	for(var/A in required_reagents)
		victim.remove_reagent(A, required_reagents[A])

///Add the returned reagents to  whoever wants it
/datum/element/plumbing_extractable/proc/grant_reagents(datum/reagents/target)
	for(var/A in returned_reagents)
		target.add_reagent(A, returned_reagents[A])

///Attempt to trade reagents from the victim to the target
/datum/element/plumbing_extractable/proc/try_trade(datum/source, datum/reagents/target, datum/reagents/victim)
	if(!has_required(victim))
		return FALSE

	take_required(victim)
	grant_reagents(target)

	return TRUE
