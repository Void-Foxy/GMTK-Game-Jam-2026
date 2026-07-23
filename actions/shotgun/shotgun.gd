extends Node2D
class_name Gun

@export var gunTip : Node2D


var explosive := preload("res://actions/explosion orb/explosion orb.tscn") 
@export var shootingForce := 100.0
var gunDir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawnExplosive() -> void:
	var thing : RigidBody2D = explosive.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = gunTip.global_position
	thing.apply_impulse(gunDir * shootingForce)
	Global.explosiveExist = true

func shoot() -> void:
	spawnExplosive()
	get_parent().knockback(-gunDir)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	gunDir = gunTip.global_position - global_position
	gunDir = gunDir.normalized()
	if Input.is_action_just_pressed("mouse right click") && !Global.explosiveExist:
		shoot()
	pass
