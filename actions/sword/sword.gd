extends Area2D

var player : RigidBody2D
@export var duration : float
@export var upForce : float
@export var sideForce : float
var abilityLockedOut := false
var abilityLockOutTime := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	print("set up" + player.to_string())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("sword action") && !abilityLockedOut:
		upSwingSword()
	if player.linear_velocity.y > 0:
		visible = false
		player.unlockPlayerMovement()
	pass

func upSwingSword() -> void:
	player.linear_velocity.y = 0
	player.apply_impulse(Vector2(sideForce * player.getFaceDir(), upForce))
	player.lockPlayerMovement()
	visible = true
	abilityLockedOut = true
	await get_tree().create_timer(abilityLockOutTime).timeout
	abilityLockedOut = false
	
