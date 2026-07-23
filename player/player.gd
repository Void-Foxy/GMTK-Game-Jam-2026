extends RigidBody2D

@export var rayCast2D: RayCast2D
var isGrounded := false
@export var jumpForce : float
@export var knockbackForce : float

var teleportOrb := preload("res://actions/teleport orb/teleport Orb.tscn") 
var lookDir : Vector2
@export var throwForce : float

var cannon := preload("res://actions/cannon/cannon.tscn") 

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("up", "down")
	if (isGrounded && vertical < 0):
		apply_impulse(Vector2(0, jumpForce))
		print("jumping")
	var force := Vector2(horizontal, 0)*2000.
	apply_central_force(force)
	# print(force)

func knockback(kb: Vector2) -> void:
	apply_impulse(kb * knockbackForce)
	#print("knockback")

func _process(delta: float) -> void:
	if (rayCast2D.get_collider() == null):
		isGrounded = false
	else:
		isGrounded = true
	lookDir = get_global_mouse_position() - global_position
	lookDir = lookDir.normalized()
	if Input.is_action_just_pressed("mouse left click") && !Global.teleportExist:
		throwTeleport()
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

func summonCannon() -> void:
	var thing : Area2D = cannon.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position - Vector2 (0,-16)
	thing.setUpCannon()
	Global.cannonExist = true
