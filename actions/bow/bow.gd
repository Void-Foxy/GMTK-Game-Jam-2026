extends Node2D

var arrow := preload("res://actions/bow/arrow.tscn") 
var player : Player
@export var actionTimeCost : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent() as Player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if player.scm.action_container.just_pressed("bow action"):
		shootBow()
	pass

func shootBow() -> void:
	var thing : RigidBody2D = arrow.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position + player.spawnThingsDir
	thing.apply_impulse(player.lookDir * player.throwForce)
