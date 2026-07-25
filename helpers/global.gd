extends Node

var player: Player

var level: Level
signal level_ready

var throwables : Node2D:
	get: return level.throwables
var explosiveExist := false
var teleportExist := false
var cannonExist := false

func emit_level_ready() -> void:
	level_ready.emit()
