extends MarginContainer

@export var restart_button: Button
@export var main_menu_button: Button


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	Global.level.restart()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
