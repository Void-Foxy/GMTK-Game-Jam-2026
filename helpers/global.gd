extends Node

var player: Player

var level_scene: PackedScene
var level: Level
signal level_ready

var throwables : Node2D:
	get: return level.throwables
var explosiveExist := false
var teleportExist := false
var cannonExist := false

func emit_level_ready() -> void:
	level_ready.emit()


func play_sound(audio_stream_player: AudioStreamPlayer2D) -> void:
	audio_stream_player.reparent(Global.level)
	audio_stream_player.play()
	var tween := get_tree().create_tween()
	tween.tween_await(audio_stream_player.finished)
	tween.tween_callback(audio_stream_player.queue_free)
