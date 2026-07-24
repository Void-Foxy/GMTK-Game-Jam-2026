extends RigidBody2D

var MOVE_SPEED := 60.
var MAX_SPEED := 200.

@export var shapeCast2D: ShapeCast2D
var isGrounded := false
@export var jumpForce : float
var isJumping : bool = false
var justJumped : bool = false
var doFallFast : bool = false
@export var knockbackForce : float

var explosive := preload("res://actions/explosion orb/explosion orb.tscn") 
var teleportOrb := preload("res://actions/teleport orb/teleport Orb.tscn") 
var lookDir : Vector2
@export var throwForce : float

var cannon := preload("res://actions/cannon/cannon.tscn") 

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("up", "down")
	
	var force := Vector2.ZERO
	linear_velocity.x *= 0.8
	
	if horizontal:
		force.x = MOVE_SPEED * horizontal
		if abs(linear_velocity.x) > MAX_SPEED:
			linear_velocity.x = MAX_SPEED * horizontal
	apply_central_impulse(force)
	#print(velocity_error, linear_velocity, " ", impulse)
	
	jumpLogic(vertical)

func jumpLogic(vertical: float) -> void:
	if (isGrounded && vertical < 0 && !justJumped):
		apply_central_impulse(Vector2(0, jumpForce))
		isJumping = true
		justJumped = true
	
	if (!isGrounded && !isJumping && vertical >= 0):
		doFallFast = true
	
	print(doFallFast)
	
	if (doFallFast):
		gravity_scale = 2.
	else:
		gravity_scale = 1.0
	
	if (shapeCast2D.is_colliding()):
		isGrounded = true
		doFallFast = false
		isJumping = false
	else:
		justJumped = false
		isGrounded = false

func knockback(kb: Vector2) -> void:
	apply_impulse(kb * knockbackForce)
	#print("knockback")

func _process(delta: float) -> void:
	lookDir = get_global_mouse_position() - global_position
	lookDir = lookDir.normalized()
	if Input.is_action_just_pressed("mouse left click") && !Global.teleportExist:
		throwTeleport()
	if Input.is_action_just_pressed("mouse right click") && !Global.explosiveExist:
		throwExplosive()
	if Input.is_action_just_pressed("cannon action") && !Global.cannonExist:
		summonCannon()
	
	pass



func throwTeleport() -> void:
	var thing : RigidBody2D = teleportOrb.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position + lookDir*2
	thing.apply_impulse(lookDir * throwForce)
	thing.setPlayer(self)
	Global.teleportExist = true

func throwExplosive() -> void:
	var thing : RigidBody2D = explosive.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position + lookDir*2
	thing.apply_impulse(lookDir * throwForce)
	Global.explosiveExist = true
	knockback(-lookDir)

func summonCannon() -> void:
	var thing : Area2D = cannon.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position - Vector2 (0,-16)
	thing.setUpCannon()
	Global.cannonExist = true
