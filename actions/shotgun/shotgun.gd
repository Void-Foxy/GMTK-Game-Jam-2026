extends Node2D
class_name Gun

@export var gunTip : Node2D


@export var shootingForce := 100.0
var gunDir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	gunDir = gunTip.global_position - global_position
	gunDir = gunDir.normalized()
	
	pass
