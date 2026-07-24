extends Node2D
class_name Level

@export var texture: Texture2D

@onready var throwables := $Throwables
@onready var tile_map_layers := $TileMapLayers
@onready var hud: Hud = $Hud
@export var main_tile_layer: MainTileLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(main_tile_layer)
	Global.level = self
	Global.emit_level_ready()
