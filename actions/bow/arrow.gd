extends RigidBody2D

var stuckIn := false
var sprite : Sprite2D
var lastFrameDir : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $Arrow
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !stuckIn:
		lastFrameDir = sprite.rotation
		sprite.look_at(global_position + linear_velocity)
	pass

func _on_body_entered(body: Node) -> void:
	sprite.rotation = lastFrameDir
	stuckIn = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	if body.is_in_group("enemy"):
		body.killThisEnemy()

func _on_body_exited(_body: Node) -> void:
	stuckIn = false
