extends PlayerState

var screen: Control:
	get: return get_child(0)
@export var text : RichTextLabel

func _ready_state() -> void:
	screen.hide()

#func _get_transition(_delta: float) -> State:
	#if all_assigned:
		#return states.Default
	#return null


func _enter_state(_old_state: State) -> void:
	get_tree().paused = true
	screen.show()
	text.text = Global.level.hud.timerLabel.text

func _exit_state(_old_state: State) -> void:
	get_tree().paused = false
	screen.hide()
