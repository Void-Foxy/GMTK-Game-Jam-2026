extends Node
class_name ActionContainer

var string_to_action: Dictionary[String, Action]

func _enter_tree() -> void:
	(get_parent().scm as SubComponentManager).action_container = self

func _ready() -> void:
	for child in get_children():
		var action := child as Action
		string_to_action[action.action_name] = action

func use_action_slot(action_name: String) -> void:
	if not string_to_action.has(action_name):
		return
	
	var action := string_to_action[action_name]
	if not action.infinite_amount:
		if action.amount <= 0:
			return
		action.amount -= 1
		
	if Global.level.timerChallenge:
		Global.player.removeTimeToChallengeTimer(action.timeCost)


func just_pressed(action_name: String, physics_process := false, ignore_handled := false) -> bool:
	if not string_to_action.has(action_name):
		return false
	
	var action := string_to_action[action_name]
	if action.disabled:
		return false

	var just_pressed_var := action.is_just_pressed
	if physics_process:
		just_pressed_var = action.is_just_pressed_physics
	
	if not just_pressed_var:
		return false
		
	
	if not ignore_handled && action.pressed_handled:
		return false
	action.pressed_handled = true
	
	if not action.infinite_amount:
		if action.amount <= 0:
			return false
	
	return true

func just_released(action_name: String, physics_process := false, ignore_handled := false) -> bool:
	if not string_to_action.has(action_name):
		return false
	
	var action := string_to_action[action_name]
	if action.disabled:
		return false

	var just_released_var := action.is_just_released
	if physics_process:
		just_released_var = action.is_just_released_physics
	
	if not just_released_var:
		return false
		
	
	if not ignore_handled && action.released_handled:
		return false
	action.released_handled = true
	
	if not action.infinite_amount:
		if action.amount <= 0:
			return false
	
	return true

func pressed(action_name: String, physics_process := false, ignore_handled := true) -> bool:
	if not string_to_action.has(action_name):
		return false
	
	var action := string_to_action[action_name]
	if action.disabled:
		return false

	var pressed_var := action.is_pressed
	if physics_process:
		pressed_var = action.is_pressed_physics
	
	if not pressed_var:
		return false
	
	if not ignore_handled && action.pressed_handled:
		return false
	
	if not action.infinite_amount:
		if action.amount <= 0:
			return false
	
	return true
