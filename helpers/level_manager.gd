extends Node

var level_info_map: Dictionary[PackedScene, LevelInfo]
var level_to_next_level: Dictionary[PackedScene, PackedScene]
var level_id_to_scene: Dictionary[String, PackedScene]

func _ready() -> void:
	var levels := FileLoader.load_scenes("res://levels/level_list/")
	
	var last_level_scene: PackedScene = null
	for level_name in levels:
		var level_scene: PackedScene = levels[level_name]
		var level_info := LevelInfo.new()
		level_info_map[level_scene] = level_info
		
		var scene_state := level_scene.get_state()
		for i in range(scene_state.get_node_property_count(0)):
			if scene_state.get_node_property_name(0, i) == "texture":
				level_info.texture = scene_state.get_node_property_value(0, i)
			elif scene_state.get_node_property_name(0, i) == "level_id":
				level_info.level_id = scene_state.get_node_property_value(0, i)
		
		assert(level_info.level_id != "", "Hi Ryan, just need to set the level id for the level")
		
		level_id_to_scene[level_info.level_id] = level_scene
		
		if last_level_scene:
			level_to_next_level[last_level_scene] = level_scene
		
		last_level_scene = level_scene

class LevelInfo:
	var texture: Texture2D
	var level_id: String
