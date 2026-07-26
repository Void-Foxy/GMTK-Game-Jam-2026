extends Node

var level_info_map: Dictionary[PackedScene, LevelInfo]
var level_to_next_level: Dictionary[PackedScene, PackedScene]
var level_id_to_scene: Dictionary[String, PackedScene]

var pack_to_ids: Dictionary[String, PackedStringArray]

# Define level paths explicitly for each pack
var pack_levels: Dictionary[String, PackedStringArray] = {
	"puzzle": [
		"res://levels/level_list/puzzle/0sniper_tut1.tscn",
		"res://levels/level_list/puzzle/0sniper_tut2.tscn",
		"res://levels/level_list/puzzle/1bow_tut.tscn",
		"res://levels/level_list/puzzle/2tp_tut.tscn",
		"res://levels/level_list/puzzle/3bomb_tut1.tscn",
		"res://levels/level_list/puzzle/3bomb_tut2.tscn",
		"res://levels/level_list/puzzle/4cannon_tut.tscn",
		"res://levels/level_list/puzzle/level_1.tscn",
		"res://levels/level_list/puzzle/level_2.tscn",
		"res://levels/level_list/puzzle/level_3.tscn",
	],
	"speedrun": [
		"res://levels/level_list/speedrun/speedrun_1.tscn",
		"res://levels/level_list/speedrun/speedrun_2.tscn",
		"res://levels/level_list/speedrun/speedrun_3.tscn",
		"res://levels/level_list/speedrun/speedrun_4.tscn",
		"res://levels/level_list/speedrun/speedrun_5.tscn",
		"res://levels/level_list/speedrun/speedrun_nessa.tscn",
	],
	"misc": [
		"res://levels/level_list/misc/extra_fireworks.tscn",
		"res://levels/level_list/misc/extra_mike.tscn",
		"res://levels/level_list/misc/level.tscn",
		"res://levels/level_list/misc/tp_tutorial.tscn",
	],
}

func _ready() -> void:
	load_levels_in_pack("puzzle")
	load_levels_in_pack("speedrun")
	load_levels_in_pack("misc")

func load_levels_in_pack(pack: String) -> void:
	if pack not in pack_levels:
		push_error("Unknown level pack: " + pack)
		return
	
	pack_to_ids[pack] = PackedStringArray()
	
	var last_level_scene: PackedScene = null
	for level_path in pack_levels[pack]:
		if ResourceLoader.exists(level_path):
			var level_scene: PackedScene = load(level_path)
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
		else:
			push_warning("Level file not found: " + level_path)

class LevelInfo:
	var texture: Texture2D
	var level_id: String
