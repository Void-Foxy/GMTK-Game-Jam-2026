extends RigidBody2D

var explosionRad : Area2D
@export var explosiveForce : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("things that can go in a cannon")
	explosionRad =  $Area2D
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse right click"):
		explode()
	pass

func explode() -> void:
	var intersectingObjs := explosionRad.get_overlapping_bodies()
	for obj in intersectingObjs:
		if (obj is RigidBody2D):
			var explosionForceDir := obj.global_position - global_position
			explosionForceDir = explosionForceDir.normalized()
			obj.apply_impulse(explosionForceDir * explosiveForce)
			if obj.is_in_group("enemy"):
				obj.killThisEnemy()
	Global.explosiveExist = false
	queue_free()
 
