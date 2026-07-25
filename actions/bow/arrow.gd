extends RigidBody2D

var stuckIn := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !stuckIn:
		look_at(global_position + linear_velocity)
	pass

func _on_body_entered(body: Node) -> void:
	if !body.is_in_group("player"):
		stuckIn = true
		call_deferred("set_freeze_enabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		reparent(body, true)
		if body.is_in_group("enemy"):
			body.killThisEnemy()
