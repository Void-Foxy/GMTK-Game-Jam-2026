extends PanelContainer
class_name AmountBankSlot

var is_enabled := true
signal was_disabled

@export var amount_label: Label
@export var amount: int:
	set(value):
		amount = value
		amount_label.text = str(value)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not is_enabled:
		return null
	
	set_drag_preview(duplicate())
	return { amount = amount, obj = self }

func disable() -> void:
	is_enabled = false
	hide()
	was_disabled.emit()
