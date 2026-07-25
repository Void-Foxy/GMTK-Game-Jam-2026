extends HFlowContainer

@export var level_select_item_scene: PackedScene

func _ready() -> void:
	print("Level Container readying")
	for level_id in LevelManager.level_id_to_scene:
		var level_scene: PackedScene = LevelManager.level_id_to_scene[level_id]
		var texture := LevelManager.level_info_map[level_scene].texture
	
		var level_select_item : LevelSelectItem = level_select_item_scene.instantiate()
		level_select_item.level_scene = level_scene
		level_select_item.label.text = level_id
		level_select_item.texture_btn.texture_normal = texture
		add_child(level_select_item)
