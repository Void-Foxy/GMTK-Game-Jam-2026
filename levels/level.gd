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
@export var timerChallengeTime : float = 300


var explosiveExist := false
var teleportExist := false
var cannonExist := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(main_tile_layer)
	Global.level = self
	Global.emit_level_ready()
	
	hud.create_amount_bank_slots(action_amounts_for_assignment)

func play_sound(audio_stream_player: AudioStreamPlayer2D) -> void:
	audio_stream_player.reparent(self)
	audio_stream_player.play()
	var tween := get_tree().create_tween()
	tween.tween_await(audio_stream_player.finished)
	tween.tween_callback(audio_stream_player.queue_free)

func play_particles(particles_node: GPUParticles2D, duration: float) -> void:
	particles_node.reparent(self)
	particles_node.emitting = true
	await get_tree().create_timer(duration).timeout
	particles_node.emitting = false
	await particles_node.finished
	particles_node.queue_free()
	

func restart() -> void:
	get_tree().change_scene_to_file(Global.level.scene_file_path)
