extends Node

var level_info_map: Dictionary[PackedScene, LevelInfo]
var level_to_next_level: Dictionary[PackedScene, PackedScene]
var level_id_to_scene: Dictionary[String, PackedScene]

var pack_to_ids: Dictionary[String, PackedStringArray]

func _ready() -> void:
	load_levels_in_pack("puzzle")
	load_levels_in_pack("speedrun")
	load_levels_in_pack("misc")

func load_levels_in_pack(pack: String) -> void:
	var levels := FileLoader.load_scenes("res://levels/level_list/" + pack + "/")
	
	pack_to_ids[pack] = PackedStringArray()
	
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
		
		assert(level_info.level_id != "")
		
		pack_to_ids[pack].append(level_info.level_id)
		
		level_id_to_scene[level_info.level_id] = level_scene
		
		if last_level_scene:
			level_to_next_level[last_level_scene] = level_scene
		
		last_level_scene = level_scene

class LevelInfo:
	var texture: Texture2D
	var level_id: String
