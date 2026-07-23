extends RigidBody2D

func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("up", "down")
	var force := Vector2(horizontal, vertical)*2000.
	apply_central_force(force)
	print(force)
