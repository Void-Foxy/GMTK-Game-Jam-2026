extends Node

@onready var action_slot_scene := preload("res://ui/hud/action_slots/action_slot.tscn")
var action_slot: ActionSlot

var container: HBoxContainer:
	get: return Global.level.hud.action_slots_container

@export var action: String

var amount: int:
	set(value):
		amount = value
		action_slot.num_uses = value

var keybind: String:
	get: 
		var events := InputMap.action_get_events("action")
		return events[0].as_text()
	set(value):
		keybind = value
		action_slot.keybind = value


func _enter_tree() -> void:
	action_slot = action_slot_scene.instantiate()
	container.add_child(action_slot)

func _exit_tree() -> void:
	container.remove_child(action_slot)
	

#func do_action() -> void:
	#
