extends RigidBody2D

var player : RigidBody2D
var enemy : RigidBody2D

@export var area2D : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("things that can go in a cannon")
	area2D.body_entered.connect(_on_body_entered)


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
			$CollisionShape2D.set_deferred("disabled", true)
			enemy = body
			linear_velocity = Vector2.ZERO
			angular_velocity = 0
			reparent(enemy, true)
	pass # Replace with function body.
