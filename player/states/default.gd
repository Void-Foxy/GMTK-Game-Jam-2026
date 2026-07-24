extends PlayerState

func _integration_state_logic(physics_state: PhysicsDirectBodyState2D) -> void:
	_movement_logic(physics_state)
	_jump_logic(physics_state)

#func _state_logic(_delta: float) -> void:
	#_jump_logic()

func _get_transition(_delta: float) -> State:
	if Input.is_action_just_pressed("sword action"):
		return states.SwordVerticalSlash
	return null
#
#
#func _enter_state(_old_state: State) -> void:
	#play_anim("idle")
