extends Area2D

@export var barrel : Node2D
@export var barrelTip : Node2D

var thingInCannnon : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if thingInCannnon != null && Input.is_action_just_pressed("cannon action"):
		fire()
	pass


func setUpCannon() -> void:
	barrel.look_at(get_global_mouse_position())

func fire() -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("things that can go in a cannon"):
		thingInCannnon = body
		thingInCannnon.freeze
		thingInCannnon.global_position = barrelTip.position
	pass # Replace with function body.
