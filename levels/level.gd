extends Node2D
class_name Level


@export var level_id: String


@onready var throwables := $Throwables
@onready var tile_map_layers := $TileMapLayers
@onready var hud: Hud = $Hud
@export var main_tile_layer: MainTileLayer

@export_category("Level Config")
@export var texture: Texture2D
@export var action_amounts_for_assignment: PackedInt32Array

@export var timerChallenge := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(main_tile_layer)
	Global.level = self
	Global.emit_level_ready()
	
	hud.create_amount_bank_slots(action_amounts_for_assignment)
