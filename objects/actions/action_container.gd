extends Node
class_name ActionContainer

var string_to_action: Dictionary[String, Action]

func _enter_tree() -> void:
	(get_parent().scm as SubComponentManager).action_container = self

func _ready() -> void:
	for child in get_children():
		var action := child as Action
		string_to_action[action.action_name] = action

func just_pressed(action_name: String) -> bool:
	var action := string_to_action[action_name]
	if not action.is_just_pressed:
		return false
	if action.amount <= 0:
		return false
	action.amount -= 1
	
	return true
