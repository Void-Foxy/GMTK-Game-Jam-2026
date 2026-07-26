extends Area2D
class_name EndFlag

signal achieved_victory

var player_touching: bool = false

func _ready() -> void:
	body_entered.connect(check_victory)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_touching = false

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_touching = false

func check_victory(body: Node2D) -> void:
	if not body is Player:
		return
	var enemies: Array[Enemy]
	enemies.assign(get_tree().get_nodes_in_group("enemy"))
	
	for enemy in enemies:
		if not enemy.died:
			return
	
	achieved_victory.emit()
	
	var fsm := (body as Player).scm.fsm
	fsm.queued_state = fsm.states.VictoryState
