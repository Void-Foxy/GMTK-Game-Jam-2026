extends PlayerState

#func _integration_state_logic(physics_state: PhysicsDirectBodyState2D) -> void:
	#_movement_logic(physics_state)
	#_jump_logic(physics_state)



func _enter_state(_old_state: State) -> void:
	fsm_owner.linear_velocity = Vector2.ZERO

func _exit_state(_new_state: State) -> void:
	fsm_owner.set_sleeping(false)
