extends Area2D

@export var barrel : Node2D
@export var barrelTip : Node2D

var thingInCannon : RigidBody2D
var dir : Vector2
@export var shootingForce : float
var hasSomething := false
@export var fireLine : Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if thingInCannon != null && Global.player.scm.action_container.just_pressed("cannon action"):
		fire()
	if thingInCannon == null && hasSomething:
		hasSomething = false
	pass


func setUpCannon() -> void:
	barrel.look_at(get_global_mouse_position())
	dir = barrelTip.global_position - barrel.global_position
	dir = dir.normalized()
	update_trajectory()

func fire() -> void:
	print("firing")
	thingInCannon.freeze = false
	await get_tree().process_frame
	thingInCannon.apply_impulse(dir * shootingForce)
	thingInCannon = null
	hasSomething = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("things that can go in a cannon") and !hasSomething:
		thingInCannon = body
		thingInCannon.call_deferred("set_freeze_enabled", true)
		thingInCannon.global_position = barrelTip.global_position
		hasSomething = true
	pass # Replace with function body.

func update_trajectory() -> void:
	fireLine.clear_points()
	var vel: Vector2 = dir
	vel *= shootingForce
	var tstep := 0.005 #time in each iteration
	var linePos := barrelTip.global_position
	var g: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	var drag : float = ProjectSettings.get_setting("physics/2d/default_linear_damp")
	fireLine.add_point(linePos)
	for i in range(1, 1000):
		vel.y += g * tstep
		linePos += vel * tstep
		vel *= clampf(1.0 - drag * tstep, 0, 1)
		fireLine.add_point(linePos)
		var query := PhysicsRayQueryParameters2D.create(linePos, linePos + vel * tstep)
		query.exclude = [self]
		var collision := get_world_2d().direct_space_state.intersect_ray(query)
		if !collision.is_empty():
			vel.y += g * tstep
			linePos += vel * tstep
			fireLine.add_point(linePos)
			break
		
	
