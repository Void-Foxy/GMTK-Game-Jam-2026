extends StaticBody2D

@onready var door_sprite := $DoorFrames

func _ready() -> void:
	open()
	await get_tree().create_timer(1.).timeout
	open()

func open() -> void:
	if door_sprite.frame == 0:
		$DoorFrames.play()
	$CollisionShape2D.call_deferred("set", "disabled", true)

func close() -> void:
	if door_sprite.frame == 2:
		$DoorFrames.play_backwards()
	$CollisionShape2D.call_deferred("set", "disabled", false)
	
