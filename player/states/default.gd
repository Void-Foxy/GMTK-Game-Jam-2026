extends PlayerState

func _integration_state_logic(physics_state: PhysicsDirectBodyState2D) -> void:
	_movement_logic(physics_state)
	_jump_logic(physics_state)


func _get_transition(_delta: float) -> State:
	if fsm_owner.scm.action_container.just_pressed("sword action", true):
		return states.SwordVerticalSlash
	return null
