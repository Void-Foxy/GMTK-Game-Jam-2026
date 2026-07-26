extends RigidBody2D

var player : Player
var other : RigidBody2D

@export var area2D : Area2D
@export var fizzler: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("things that can go in a cannon")
	area2D.body_entered.connect(_on_body_entered)
	fizzler.body_entered.connect(_on_fizzler_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var teleport_action := "teleport action"
	if player.scm.action_container.just_pressed(teleport_action, false, false):
		#player.scm.action_container.use_action_slot(teleport_action)
		teleport()
	pass

func setPlayer(p : RigidBody2D) -> void:
	player = p

func teleport() -> void:
	var orb_velocity := linear_velocity
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	if other == null:
		player.global_position = global_position
	else:
		var tempPos := other.global_position
		other.global_position = player.global_position
		player.global_position = tempPos
	
	player.linear_velocity = orb_velocity
	Global.teleportExist = false
	queue_free()

func get_destroyed() -> void:
	Global.teleportExist = false
	queue_free()

func _on_fizzler_body_entered(body: Node) -> void:
	if body is TileMapLayer:
		get_destroyed()

func _on_body_entered(body: Node) -> void:
	if body == self:
		return
	if body.is_in_group("player"):
		return
	
	call_deferred("set_freeze_enabled", true)
	if body.is_in_group("teleportable"):
		collision_mask -= 2**(2-1)
		
		#$CollisionShape2D.set_deferred("disabled", true)
		other = body
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		reparent(other, true)
		if other is ExplosiveOrb:
			other.attachTeleport(self)
	pass # Replace with function body.
