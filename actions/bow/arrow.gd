extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	look_at(position + linear_velocity)
	pass

func _on_body_entered(body: Node) -> void:
	if !body.is_in_group("player"):
		call_deferred("set_freeze_enabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		reparent(body, true)
