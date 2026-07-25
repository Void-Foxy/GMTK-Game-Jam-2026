extends RigidBody2D
class_name Player

var scm := SubComponentManager.new()



var MOVE_FORCE := 3600
var MAX_SPEED := 200.

var faceDir : float
var playerMovementLocked := false

@export var shapeCast2D: ShapeCast2D
var isGrounded := false
@export var jumpForce : float
var isJumping : bool = false
var justJumped : bool = false
var doFallFast : bool = false
@export var knockbackForce : float

var explosive := preload("res://actions/explosion orb/explosion orb.tscn") 
var teleportOrb := preload("res://actions/teleport orb/teleport Orb.tscn") 
var arrow := preload("res://actions/bow/arrow.tscn") 
var lookDir : Vector2
var spawnThingsDir : Vector2
@export var throwForce : float
@export var throwForceBase : float
@export var throwForceUpperLimit : float
@export var throwForceChargeTime : float
var throwForceChargeTimer := 0.0
var throwForceCharging := false

var throwLine : Line2D

var cannon := preload("res://actions/cannon/cannon.tscn") 

@export var sword : Area2D
var swordOffset : float

@onready var timer : Timer = $Timer
var label : Label
var timeElapsed := 0

var canThrowTele := false
var canThrowExplosive := false
var canShootBow := false

func _ready() -> void:
	Global.player = self
	add_to_group("player")
	swordOffset = sword.position.x
	throwLine = $Line2D
	
	await get_tree().process_frame
	label = Global.level.hud.timerLabel
	if !Global.level.timerChallenge:
		timer.wait_time = 1
		timer.one_shot = false
		label.text = "00:00"
	else:
		timer.wait_time = Global.level.timerChallengeTime
	timer.start()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	scm.fsm.state._integration_state_logic(state)


func knockback(kb: Vector2) -> void:
	apply_impulse(kb * knockbackForce)
	#print("knockback")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hard_restart"):
		get_tree().change_scene_to_file(Global.level.scene_file_path)

func _process(delta: float) -> void:
	lookDir = get_global_mouse_position() - global_position
	lookDir = lookDir.normalized()
	spawnThingsDir = lookDir * 4
	var teleport_action := "teleport action"
	var explosion_action := "explosion action"
	var cannon_action := "cannon action"
	var bow_action := "bow action"
	
	if scm.action_container.just_pressed(teleport_action) && !Global.teleportExist:
		canThrowTele = true
	if scm.action_container.just_pressed(explosion_action) && !Global.explosiveExist:
		canThrowExplosive = true
	if scm.action_container.just_pressed(cannon_action) && !Global.cannonExist:
		scm.action_container.use_action_slot(cannon_action)
		summonCannon()
	
	if scm.action_container.just_released(teleport_action) && canThrowTele:
		scm.action_container.use_action_slot(teleport_action)
		throwTeleport()
		canThrowTele = false
	if scm.action_container.just_released(explosion_action) && canThrowExplosive:
		scm.action_container.use_action_slot(explosion_action)
		throwExplosive()
		canThrowExplosive = false
	if scm.action_container.just_released(bow_action):
		scm.action_container.use_action_slot(bow_action)
		shootBow()
	
	if scm.action_container.pressed(explosion_action)\
	 or scm.action_container.pressed(teleport_action)\
	 or scm.action_container.pressed(bow_action):
		if canThrowTele or canThrowExplosive or scm.action_container.pressed(bow_action):
			throwForceChargeTimer += delta
			if throwForceChargeTimer > throwForceChargeTime:
				throwForceChargeTimer = throwForceChargeTime
			throwForce = lerp(throwForceBase, throwForceUpperLimit, throwForceChargeTimer / throwForceChargeTime)
			update_trajectory()
	else:
		throwForceChargeTimer = 0.0
		throwLine.clear_points()
	
	if Global.level.timerChallenge:
		updateTimer()
	pass



func removeTimeToChallengeTimer(time : float) -> void:
	timer.start(timer.time_left - time)

func throwTeleport() -> void:
	var thing : RigidBody2D = teleportOrb.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position + spawnThingsDir
	thing.apply_impulse(lookDir * throwForce)
	thing.setPlayer(self)
	Global.teleportExist = true

func throwExplosive() -> void:
	var thing : RigidBody2D = explosive.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position + spawnThingsDir
	thing.apply_impulse(lookDir * throwForce)
	Global.explosiveExist = true

func shootBow() -> void:
	var thing : RigidBody2D = arrow.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position + spawnThingsDir
	thing.apply_impulse(lookDir * throwForce)

func summonCannon() -> void:
	var thing : Area2D = cannon.instantiate()
	Global.throwables.add_child(thing)
	thing.global_position = global_position - Vector2 (0,-16)
	thing.setUpCannon()
	Global.cannonExist = true

func getFaceDir() -> float:
	return faceDir

func setSwordSide(side : float) -> void:
	sword.position.x = swordOffset * side

func lockPlayerMovement() -> void:
	playerMovementLocked = true
	doFallFast = true
	gravity_scale = 2.

func unlockPlayerMovement() -> void:
	playerMovementLocked = false
	doFallFast = false
	gravity_scale = 1.0

func update_trajectory() -> void:
	throwLine.clear_points()
	var vel: Vector2 = lookDir
	vel *= throwForce
	var tstep := 0.005 #time in each iteration
	var linePos := global_position + spawnThingsDir
	var g: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	var drag : float = ProjectSettings.get_setting("physics/2d/default_linear_damp")
	throwLine.add_point(linePos)
	for i in range(1, 1000):
		vel.y += g * tstep
		linePos += vel * tstep
		vel *= clampf(1.0 - drag * tstep, 0, 1)
		throwLine.add_point(linePos)
		var query := PhysicsRayQueryParameters2D.create(linePos, linePos + vel * tstep)
		query.exclude = [self]
		query.collision_mask = query.collision_mask - 2**(24-1)
		var collision := get_world_2d().direct_space_state.intersect_ray(query)
		if !collision.is_empty():
			vel.y += g * tstep
			linePos += vel * tstep
			throwLine.add_point(linePos)
			break
		
	

func timeLeft() -> Array:
	var tl := timer.time_left
	var minute : int = floor(tl / 60)
	var seconds : int = int(tl) % 60
	var miliseconds : int = fmod(tl, 1.0) * 1000
	return [minute, seconds, miliseconds]

func updateTimer() -> void:
	label.text = "%02d:%02d:%02d" % timeLeft()


func _on_timer_timeout() -> void:
	if !Global.level.timerChallenge:
		timeElapsed += 1
		var minute : int = floor(timeElapsed / 60)
		var seconds : int = timeElapsed % 60
		label.text = "%02d:%02d" % [minute, seconds]
	pass # Replace with function body.
