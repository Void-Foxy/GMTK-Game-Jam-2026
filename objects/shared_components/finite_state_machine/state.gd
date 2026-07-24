extends Node
class_name State

var states: Dictionary[String, State]:
	get:
		return state_machine.states

var state_machine: StateMachine

enum priorities { LOW, MED, HIGH }

var priority := priorities.LOW


func _enter_tree() -> void:
	state_machine = get_parent()
	state_machine.add_state(self)


func _ready() -> void:
	set_physics_process(false)
	set_process_unhandled_input(false)
	_ready_state()


func _exit_tree() -> void:
	state_machine.remove_state(self)
	state_machine = null


func _ready_state() -> void:
	pass


func _physics_process(delta: float) -> void:
	_state_logic(delta)
	var transition := _get_transition(delta)
	transition = _get_queued_state_transition(transition)
	if transition != null:
		state_machine.set_state(transition)
	state_machine.animation_status = {}
	state_machine.queued_state = null


func _state_logic(_delta: float) -> void:
	pass


func _get_transition(_delta: float) -> State:
	return null


func _get_queued_state_transition(transition: State) -> State:
	if !state_machine.queued_state:
		return transition
	if priority > state_machine.queued_state.priority:
		return transition
	if !transition:
		return state_machine.queued_state
	if state_machine.queued_state.priority >= transition.priority:
		return state_machine.queued_state
	return transition


func _enter_state(_old_state: State) -> void:
	pass


func _exit_state(_new_state: State) -> void:
	pass


func play_anim(animation: String, restart_animation := false) -> void:
	state_machine.play_anim(animation, restart_animation)
