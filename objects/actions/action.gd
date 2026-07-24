extends Node
class_name Action

var action_slot_scene := preload("res://ui/hud/action_slots/action_slot.tscn")
var action_slot: ActionSlot

var container: HBoxContainer:
	get: 
		if not Global.level:
			return null
		return Global.level.hud.action_slots_container

@export var action_name: String
var is_just_pressed: bool

@export var amount: int = 4:
	set(value):
		amount = value
		action_slot.num_uses = value

var keybind: String:
	get: 
		var events := InputMap.action_get_events(action_name)
		print(events)
		return events[0].as_text()
	set(value):
		keybind = value
		action_slot.keybind = value


func _enter_tree() -> void:
	action_slot = action_slot_scene.instantiate()
	if not container:
		await Global.level_ready
		
	amount = amount
	keybind = keybind
	container.add_child(action_slot)

func _exit_tree() -> void:
	container.remove_child(action_slot)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(action_name):
		is_just_pressed = true
	else:
		is_just_pressed = false
