extends Control

@export var puzzle_btn: Button
@export var speedrun_btn: Button
@export var misc_btn: Button
@export var back: Button

@export var level_select_scene: PackedScene

func _ready() -> void:
	puzzle_btn.pressed.connect(_on_puzzle_pressed)
	speedrun_btn.pressed.connect(_on_speedrun_pressed)
	misc_btn.pressed.connect(_on_misc_pressed)
	back.pressed.connect(_on_main_menu_pressed)
	

func _on_puzzle_pressed() -> void:
	Global.level_pack_selected = "puzzle"
	get_tree().change_scene_to_node(level_select_scene.instantiate())

func _on_speedrun_pressed() -> void:
	Global.level_pack_selected = "speedrun"
	get_tree().change_scene_to_node(level_select_scene.instantiate())

func _on_misc_pressed() -> void:
	Global.level_pack_selected = "misc"
	get_tree().change_scene_to_node(level_select_scene.instantiate())

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
