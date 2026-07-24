extends Node2D
class_name Gun

@export var gunTip : Node2D
var player : RigidBody2D

@export var shootingForce := 100.0
var gunDir : Vector2

var tracer := preload("res://actions/shotgun/bullet tracer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	gunDir = gunTip.global_position - global_position
	gunDir = gunDir.normalized()
	if Input.is_action_just_pressed("shotgun action"):
		shoot()
	pass

func shoot() -> void:
	var query := PhysicsRayQueryParameters2D.create(gunTip.global_position, gunTip.global_position + gunDir * 200000)
	query.exclude = [self]
	var collision := get_world_2d().direct_space_state.intersect_ray(query)
	var dist : float = gunTip.global_position.distance_to(collision.position)
	var thing : Node2D = tracer.instantiate()
	Global.throwables.add_child(thing)
	thing.scale.x *= dist
	thing.global_position = gunTip.global_position
	thing.rotation = rotation
	player.knockback(-gunDir)
	if collision.collider != null:
		if collision.collider.is_in_group("enemy"):
			var enemy : RigidBody2D = collision.collider
			enemy.apply_impulse(gunDir * shootingForce)
