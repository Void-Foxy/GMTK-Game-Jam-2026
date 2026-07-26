extends StaticBody2D

@onready var door_sprite := $DoorFrames

var door_open := false

func open() -> void:
	if door_sprite.frame != 3:
		$DoorFrames.play()
	$CollisionShape2D.call_deferred("set", "disabled", true)

func close() -> void:
	if door_sprite.frame != 0:
		$DoorFrames.play_backwards()
	$CollisionShape2D.call_deferred("set", "disabled", false)

func interaction_input(_value: bool) -> void:
	door_open = !door_open
	if door_open:
		open()
	else:
		close()
