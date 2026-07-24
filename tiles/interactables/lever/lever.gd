extends Area2D


signal output(value: bool)

var toggled_on := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func interaction_output() -> void:
	toggled_on = !toggled_on
	output.emit(toggled_on)
	print("outputting")

func _on_body_entered(_body: Node2D) -> void:
	interaction_output()
