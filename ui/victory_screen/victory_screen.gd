extends MarginContainer

@export var restart_button: Button
@export var next_level_button: Button


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)
	next_level_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file(Global.level.scene_file_path)

func _on_next_level_pressed() -> void:
	var current_level_scene := LevelManager.level_id_to_scene[Global.level.level_id]
	var next_level_scene := LevelManager.level_to_next_level[current_level_scene]
	get_tree().change_scene_to_node(next_level_scene.instantiate())
