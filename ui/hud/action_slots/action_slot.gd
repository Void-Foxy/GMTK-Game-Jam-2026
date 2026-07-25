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

func set_texture(texture: Texture2D) -> void:
	texture_rect.texture = texture
