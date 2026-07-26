extends Node

var player : Player

var level_pack_selected: String
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

func check_victory() -> void:
	
	var end_flags: Array[EndFlag]
	end_flags.assign(get_tree().get_nodes_in_group("end_flag"))
	
	var success_flag: EndFlag
	var player_on_flag := false
	for flag in end_flags:
		if flag.player_touching:
			player_on_flag = true
			success_flag = flag
	
	if not player_on_flag:
		return
	
	var enemies: Array[Enemy]
	enemies.assign(get_tree().get_nodes_in_group("enemy"))
	
	for enemy in enemies:
		if not enemy.died:
			return
	
	success_flag.achieved_victory.emit()
	
	var fsm := Global.player.scm.fsm
	fsm.queued_state = fsm.states.VictoryState
