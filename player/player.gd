extends RigidBody2D
class_name Player

var scm := SubComponentManager.new()



var MOVE_FORCE := 3600
var MAX_SPEED := 200.

var faceDir : float
var playerMovementLocked := false

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

@export var sword : Area2D
var swordOffset : float


func _ready() -> void:
	add_to_group("player")
	swordOffset = sword.position.x

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	scm.fsm.state._integration_state_logic(state)


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

func getFaceDir() -> float:
	return faceDir

func setSwordSide(side : float) -> void:
	sword.position.x = swordOffset * side

func lockPlayerMovement() -> void:
	playerMovementLocked = true

func unlockPlayerMovement() -> void:
	playerMovementLocked = false
