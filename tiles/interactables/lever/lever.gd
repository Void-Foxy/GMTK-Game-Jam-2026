extends Area2D


signal output(value: bool)

var toggled_on := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func interaction_output() -> void:
	if toggled_on:
		$AnimatedSprite2D.play("", -1)
	else:
		$AnimatedSprite2D.play()
	toggled_on = !toggled_on
	print(toggled_on)
	output.emit(toggled_on)

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		return
	interaction_output()
