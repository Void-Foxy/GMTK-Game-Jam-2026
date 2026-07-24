extends PlayerState

@export var sword: Sword


@export var upForce : float = -800.
@export var sideForce : float = 400.

@export var duration := 1000.
var start_time_msec: float = Time.get_ticks_msec()

var do_upswing := false

func _integration_state_logic(physics_state: PhysicsDirectBodyState2D) -> void:
	_movement_logic(physics_state, 0.2)
	if do_upswing:
		upSwingSword(physics_state)
		do_upswing = false

#func _state_logic(_delta: float) -> void:
	#_jump_logic()

func _get_transition(_delta: float) -> State:
	if Time.get_ticks_msec() - start_time_msec >= duration:
		return states.Default
	if fsm_owner.linear_velocity.y > 0:
		return states.Default
	return null

func _enter_state(_old_state: State) -> void:
	start_time_msec = Time.get_ticks_msec()
	fsm_owner.gravity_scale = 3.
	
	do_upswing = true
	sword.visible = true


func _exit_state(_new_state: State) -> void:
	do_upswing = false
	sword.visible = false


func upSwingSword(physics_state: PhysicsDirectBodyState2D) -> void:
	physics_state.linear_velocity.y = 0
	physics_state.apply_impulse(Vector2(sideForce * fsm_owner.getFaceDir(), upForce))
