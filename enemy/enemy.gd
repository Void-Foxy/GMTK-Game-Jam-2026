extends RigidBody2D

@export var rayCast2D: RayCast2D
@export var fallVelocityKill : float
var killOnGround := false
var died := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if linear_velocity.y > fallVelocityKill && !killOnGround:
		killOnGround = true
	if (rayCast2D.get_collider() != null && killOnGround):
		died = true
		print("this enemy is dead")
	pass

func killThisEnemy() -> void:
	print("enemy exploded")
	died = true
