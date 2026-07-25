extends PlayerState

var all_assigned := false

func _get_transition(_delta: float) -> State:
	if all_assigned:
		return states.Default
	return null


func _enter_state(_old_state: State) -> void:
	all_assigned = false
	get_tree().paused = true
	if not Global.level:
		await Global.level_ready
	if not Global.level.hud.are_amount_bank_slots_ready:
		await Global.level.hud.amount_bank_slots_readied
	if Global.level.hud.all_disabled:
		all_assigned = true
	else:
		Global.level.hud.all_actions_assigned.connect(func() -> void: all_assigned = true, CONNECT_ONE_SHOT)
	pass

func _exit_state(_new_state: State) -> void:
	get_tree().paused = false
