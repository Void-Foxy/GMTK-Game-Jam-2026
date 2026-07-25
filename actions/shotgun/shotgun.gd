extends Node2D
class_name Gun

@export var gunTip : Node2D
var player : RigidBody2D

@export var shootingForce := 100.0
var gunDir : Vector2

var tracer := preload("res://actions/shotgun/bullet tracer.tscn")

@onready var line : Line2D = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	update_trajectory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	gunDir = gunTip.global_position - global_position
	gunDir = gunDir.normalized()
	var shotgun_action := "shotgun action"
	if Global.player.scm.action_container.just_pressed(shotgun_action):
		Global.player.scm.action_container.use_action_slot(shotgun_action)
		shoot()
	pass

func shoot() -> void:
	var query := PhysicsRayQueryParameters2D.create(gunTip.global_position, gunTip.global_position + gunDir * 200000)
	query.exclude = [self]
	query.collision_mask = Global.trajectoryMask
	var collision := get_world_2d().direct_space_state.intersect_ray(query)
	player.knockback(-gunDir)
	if !collision.is_empty():
		var dist : float = gunTip.global_position.distance_to(collision.position)
		var thing : Node2D = tracer.instantiate()
		Global.throwables.add_child(thing)
		thing.scale.x *= dist
		thing.global_position = gunTip.global_position
		thing.rotation = rotation
		if collision.collider != null:
			if collision.collider is RigidBody2D:
				collision.collider.apply_impulse(gunDir * shootingForce)
				if collision.collider.is_in_group("enemy"):
					collision.collider.killThisEnemy()
					

func update_trajectory() -> void:
	line.clear_points()
	var query := PhysicsRayQueryParameters2D.create(gunTip.global_position, gunTip.global_position + gunDir * 200000)
	query.exclude = [self]
	query.collision_mask = Global.trajectoryMask
	var collision := get_world_2d().direct_space_state.intersect_ray(query)
	if !collision.is_empty():
		line.add_point(gunTip.global_position)
		line.add_point(collision.position)
		
