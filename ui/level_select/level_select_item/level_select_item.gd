extends PanelContainer

@export var texture_btn: TextureButton
@export var label: Label

@export var level_scene: PackedScene

var level: Level

func _ready() -> void:
	level = level_scene.instantiate()
	label.text = level.name
	texture_btn.texture_normal = level.texture
