extends MarginContainer


@export var restart_button: Button
@export var main_menu_button: Button
@export var next_level_button: Button

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	if not Global.level:
		await Global.level_ready
	var current_level_scene := LevelManager.level_id_to_scene[Global.level.level_id]
	if current_level_scene && !LevelManager.level_to_next_level.has(current_level_scene):
		next_level_button.hide()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	Global.level.restart()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

func _on_next_level_pressed() -> void:
	var current_level_scene := LevelManager.level_id_to_scene[Global.level.level_id]
	var next_level_scene := LevelManager.level_to_next_level[current_level_scene]
	get_tree().change_scene_to_node(next_level_scene.instantiate())
