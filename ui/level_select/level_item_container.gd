extends HFlowContainer

@export var level_select_item_scene: PackedScene

func _ready() -> void:
	var levels := FileLoader.load_scenes("res://levels/level_list/")
	
	for level_name in levels:
		var level_scene: PackedScene = levels[level_name]
		var texture: Texture2D
		
		var scene_state := level_scene.get_state()
		for i in range(scene_state.get_node_property_count(0)):
			if scene_state.get_node_property_name(0, i) == "texture":
				texture = scene_state.get_node_property_value(0, i)
				break
		
		var level_select_item : LevelSelectItem = level_select_item_scene.instantiate()
		level_select_item.level_scene = level_scene
		level_select_item.label.text = level_name
		level_select_item.texture_btn.texture_normal = texture
		add_child(level_select_item)
