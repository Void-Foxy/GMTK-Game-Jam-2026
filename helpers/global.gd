extends Node

var player: Player

var level_scene: PackedScene
var level: Level
signal level_ready

@onready var trajectoryMask := 0xFFFFFFFF - 2**(24-1) - 2**(17-1)

var throwables : Node2D:
	get: return level.throwables
var explosiveExist: bool:
	set(value):
		level.explosiveExist = value
	get: return level.explosiveExist
var teleportExist: bool:
	set(value):
		level.teleportExist = value
	get: return level.teleportExist

var cannonExist: bool:
	set(value):
		level.cannonExist = value
	get: return level.cannonExist

func emit_level_ready() -> void:
	level_ready.emit()
