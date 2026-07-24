extends State
class_name PlayerState

var fsm_owner: Player

func _enter_tree() -> void:
	super()
	fsm_owner = owner

func _integration_state_logic(_physics_state: PhysicsDirectBodyState2D) -> void:
	# This is called directly by the fsm_owner in its own _integrate_forces function
	pass


func _movement_logic(physics_state: PhysicsDirectBodyState2D, factor := 1.) -> void:
	var horizontal := Input.get_axis("left", "right")
	
	var force := Vector2.ZERO
	physics_state.linear_velocity.x *= 0.8
	
	if horizontal > 0:
		fsm_owner.faceDir = 1
	elif horizontal < 0:
		fsm_owner.faceDir = -1
	fsm_owner.setSwordSide(fsm_owner.faceDir)
	if !fsm_owner.playerMovementLocked:
		if horizontal:
			force.x = fsm_owner.MOVE_FORCE * horizontal * factor
			#if abs(linear_velocity.x) > MAX_SPEED:
				#linear_velocity.x = MAX_SPEED * horizontal
		physics_state.apply_central_force(force)
		#print(velocity_error, linear_velocity, " ", impulse)


func _jump_logic(physics_state: PhysicsDirectBodyState2D) -> void:
	var vertical := Input.get_axis("up", "down")
	if (fsm_owner.isGrounded && vertical < 0 && !fsm_owner.justJumped && !fsm_owner.playerMovementLocked):
		physics_state.apply_central_impulse(Vector2(0, fsm_owner.jumpForce))
		print(Vector2(0, fsm_owner.jumpForce))
		fsm_owner.isJumping = true
		fsm_owner.justJumped = true
	
	if (!fsm_owner.isGrounded && !fsm_owner.isJumping && vertical >= 0):
		fsm_owner.doFallFast = true
	
	#print(doFallFast)k
	
	if (fsm_owner.doFallFast):
		fsm_owner.gravity_scale = 2.
	else:
		fsm_owner.gravity_scale = 1.0
	
	if (fsm_owner.shapeCast2D.is_colliding()):
		fsm_owner.isGrounded = true
		fsm_owner.doFallFast = false
		fsm_owner.isJumping = false
	else:
		fsm_owner.justJumped = false
		fsm_owner.isGrounded = false
