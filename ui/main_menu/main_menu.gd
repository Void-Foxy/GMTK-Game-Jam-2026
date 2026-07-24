extends Control

@export var level_select : Button
@export var exit_game : Button


func _ready() -> void:
	level_select.pressed.connect(_on_level_select)
	exit_game.pressed.connect(_on_exit_game)

func _on_level_select() -> void:
	pass

func _on_exit_game() -> void:
	get_tree().quit()
