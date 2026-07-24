extends PanelContainer
class_name ActionSlot

var num_uses: int:
	set(value): 
		num_uses = value
		amount_label.text = str(value)
var keybind: String:
	set(value): 
		keybind = value
		keybind_label.text = value

@export var amount_label: Label
@export var keybind_label: Label
