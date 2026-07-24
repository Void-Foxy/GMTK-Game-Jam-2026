extends TileMapLayer
class_name WiringTileLayer

var wired_nodes: Array[Node]

func _ready() -> void:
	await get_tree().process_frame
	var coords := get_used_cells()
	var main_layer: MainTileLayer
	for child in get_parent().get_children():
		if child is MainTileLayer:
			main_layer = child
			break
	var coord_to_node := main_layer.coord_to_node
	print(coord_to_node)
	for coord in coords:
		if coord_to_node.has(coord):
			wired_nodes.append(coord_to_node[coord])
	
	var output_nodes: Array[Node]
	for node in wired_nodes:
		if node.has_signal("output"):
			output_nodes.append(node)
	for node in wired_nodes:
		if node.has_method("interaction_input"):
			for output_node in output_nodes:
				(output_node.output as Signal).connect(node.interaction_input)
