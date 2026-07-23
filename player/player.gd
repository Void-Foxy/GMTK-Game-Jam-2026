extends RigidBody2D

@export var rayCast2D: RayCast2D
var isGrounded := false
@export var jumpForce : float
@export var knockbackForce : float

func _physics_process(delta: float) -> void:
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("up", "down")
	if (isGrounded && vertical < 0):
		apply_impulse(Vector2(0, jumpForce))
		print("jumping")
	var force := Vector2(horizontal, 0)*2000.
	apply_central_force(force)
	# print(force)

func knockback(kb: Vector2) -> void:
	apply_impulse(kb * knockbackForce)
	#print("knockback")

func _process(delta: float) -> void:
	if (rayCast2D.get_collider() == null):
		isGrounded = false
	else:
		isGrounded = true
	pass
	
