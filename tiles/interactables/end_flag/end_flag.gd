extends Area2D
class_name EndFlag

signal achieved_victory

func _ready() -> void:
	body_entered.connect(check_victory)

func check_victory(body: Node2D) -> void:
	if not body is Player:
		return
	print("Checking victory")
	var enemies: Array[Enemy]
	enemies.assign(get_tree().get_nodes_in_group("enemy"))
	
	for enemy in enemies:
		if not enemy.died:
			return
	
	achieved_victory.emit()
	
	var fsm := (body as Player).scm.fsm
	fsm.queued_state = fsm.states.VictoryState
