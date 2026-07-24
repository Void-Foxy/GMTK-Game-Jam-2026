extends PanelContainer
class_name LevelSelectItem

@export var texture_btn: TextureButton
@export var label: Label

@export var level_scene: PackedScene

func _on_texture_button_pressed() -> void:
	var level: Level = level_scene.instantiate()
	get_tree().change_scene_to_node(level)
