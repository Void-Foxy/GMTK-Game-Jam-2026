extends PlayerState

var victory_screen: Control:
	get: return get_child(0)

func _ready_state() -> void:
	victory_screen.hide()

#func _get_transition(_delta: float) -> State:
	#if all_assigned:
		#return states.Default
	#return null


func _enter_state(_old_state: State) -> void:
	get_tree().paused = true
	victory_screen.show()

func _exit_state(_old_state: State) -> void:
	get_tree().paused = false
	victory_screen.hide()
