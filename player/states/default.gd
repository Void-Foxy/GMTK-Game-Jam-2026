extends PlayerState

func _integration_state_logic(physics_state: PhysicsDirectBodyState2D) -> void:
	_movement_logic(physics_state)
	_jump_logic(physics_state)


func _get_transition(_delta: float) -> State:
	var sword_action := "sword action"
	if fsm_owner.scm.action_container.just_pressed(sword_action, true):
		fsm_owner.scm.action_container.use_action_slot(sword_action)
		return states.SwordVerticalSlash
	return null
