extends RigidBody2D

var player : RigidBody2D
var enemy : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("things that can go in a cannon")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse left click"):
		teleport()
	pass

func setPlayer(p : RigidBody2D) -> void:
	player = p

func teleport() -> void:
	if enemy == null:
		$CollisionShape2D.set_deferred("disabled", true)
		player.global_position = global_position
		Global.teleportExist = false
	else:
		$CollisionShape2D.set_deferred("disabled", true)
		var tempPos := enemy.global_position
		enemy.position = player.position
		player.position = tempPos
		Global.teleportExist = false
	queue_free()


func _on_body_entered(body: Node) -> void:
	if !body.is_in_group("player"):
		call_deferred("set_freeze_enabled", true)
		if body.is_in_group("enemy"):
			enemy = body
			freeze_mode = FreezeMode.FREEZE_MODE_KINEMATIC
			enemy.add_child(self)
	pass # Replace with function body.
