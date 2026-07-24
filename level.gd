extends Node2D
class_name Level

@onready var throwables := $throwables

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
