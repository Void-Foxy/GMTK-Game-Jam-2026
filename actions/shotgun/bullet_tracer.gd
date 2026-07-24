extends Node2D

@export var fadeDelay : float
@export var fadeDuration : float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func fade() -> void:
	await get_tree().create_timer(fadeDelay).timeout
	var tween := get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1,1,1,0), fadeDuration)
	tween.tween_callback(func() -> void: queue_free())
	
