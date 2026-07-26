extends StaticBody2D

@onready var door_sprite := $DoorFrames



func open() -> void:
	if door_sprite.frame != 3:
		$DoorFrames.play()
	$CollisionShape2D.call_deferred("set", "disabled", true)

func close() -> void:
	if door_sprite.frame != 0:
		$DoorFrames.play_backwards()
	$CollisionShape2D.call_deferred("set", "disabled", false)

func interaction_input(value: bool) -> void:
	if value:
		open()
	else:
		close()
