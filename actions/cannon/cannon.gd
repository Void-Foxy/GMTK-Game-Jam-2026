extends Area2D

@export var barrel : Node2D
@export var barrelTip : Node2D

var thingInCannon : RigidBody2D
var dir : Vector2
@export var shootingForce : float
var hasSomething := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if thingInCannon != null && Input.is_action_just_pressed("cannon action"):
		fire()
	if thingInCannon == null && hasSomething:
		hasSomething = false
	pass


func setUpCannon() -> void:
	barrel.look_at(get_global_mouse_position())
	dir = barrelTip.global_position - barrel.global_position
	dir = dir.normalized()

func fire() -> void:
	print("firing")
	thingInCannon.freeze = false
	await get_tree().process_frame
	thingInCannon.apply_impulse(dir * shootingForce)
	hasSomething = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("things that can go in a cannon") and !hasSomething:
		thingInCannon = body
		thingInCannon.call_deferred("set_freeze_enabled", true)
		thingInCannon.global_position = barrelTip.global_position
		hasSomething = true
	pass # Replace with function body.
