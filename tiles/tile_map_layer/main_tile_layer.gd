extends TileMapLayer
class_name MainTileLayer

var coord_to_node: Dictionary[Vector2i, Node]

func _ready() -> void:
	var scene_coords: Array[Vector2i]
	for coord in get_used_cells():
		var source_id := get_cell_source_id(coord)
		if source_id > -1:
			var scene_source := tile_set.get_source(source_id)
			if scene_source is TileSetScenesCollectionSource:
				scene_coords.append(coord)
	
	await get_tree().process_frame
	
	for i in range(len(get_children())):
		var child := get_child(i)
		if i > scene_coords.size():
			push_error("TileMapLayer child mismatch")
		coord_to_node[scene_coords[i]] = child
	
	print(coord_to_node)
