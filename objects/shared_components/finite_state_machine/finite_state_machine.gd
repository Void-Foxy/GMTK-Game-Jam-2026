extends Node
class_name StateMachine

var state: State
var previous_state: State
var queued_state: State:
	set = set_queued_state
var states: Dictionary[String, State]= {}

var animation_status := {}
var last_action_effect := ""


var fsm_owner: Node

signal animation_finished(state: State)
signal state_changed(previous_state: State, new_state: State)


func _enter_tree() -> void:
	fsm_owner = get_parent()
	(fsm_owner.scm as SubComponentManager).fsm = self


func _ready() -> void:
	set_state(get_child(0))


func set_state(new_state: State) -> void:
	previous_state = state
	state = new_state
	if previous_state != null:
		previous_state._exit_state(new_state)
		previous_state.set_physics_process(false)
		new_state.set_process_unhandled_input(false)
	if new_state != null:
		new_state.set_physics_process(true)
		new_state.set_process_unhandled_input(true)
		new_state._enter_state(previous_state)

	state_changed.emit(previous_state, new_state)


func add_state(new_state: State) -> void:
	states[new_state.name] = new_state


func remove_state(state_to_delete: State) -> void:
	states.erase(state_to_delete.name)


func _on_external_state_change(new_state: State) -> void:
	queued_state = new_state


func set_queued_state(value: State) -> void:
	if queued_state && state && queued_state.priority < state.priority:
		return
	queued_state = value


func _on_action_effect_started(action: String) -> void:
	last_action_effect = action
