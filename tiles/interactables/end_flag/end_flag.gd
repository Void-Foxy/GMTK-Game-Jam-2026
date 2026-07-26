extends Area2D
class_name EndFlag

signal achieved_victory

var player_touching: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_touching = true
		Global.check_victory()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_touching = false
