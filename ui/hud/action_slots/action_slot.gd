extends PanelContainer
class_name ActionSlot

var action: Action

var num_uses: int:
	set(value): 
		num_uses = value
		if action && action.infinite_amount:
			amount_label.text = ""
		else:
			amount_label.text = str(value)
var keybind: String:
	set(value): 
		keybind = value
		keybind_label.text = value

@export var amount_label: Label
@export var keybind_label: Label
@export var texture_rect: TextureRect

var already_dropped := false

func set_texture(texture: Texture2D) -> void:
	texture_rect.texture = texture

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if already_dropped:
		return false
	return "amount" in data

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	action.infinite_amount = false
	action.amount = data.amount
	
	data.obj.disable()
	already_dropped = true
