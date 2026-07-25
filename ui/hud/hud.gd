extends Control
class_name Hud

@export var action_amount_bank_slot_scene: PackedScene

@export var action_amount_bank: HBoxContainer
@export var action_slots_container: HBoxContainer
@export var timerLabel : Label 

var are_amount_bank_slots_ready := false
signal amount_bank_slots_readied
signal all_actions_assigned

var disabled_bank_slots: Array[AmountBankSlot]
var all_disabled: bool:
	get: return disabled_bank_slots.size() >= action_amount_bank.get_child_count()

func create_amount_bank_slots(amount_list: PackedInt32Array) -> void:
	for amount in amount_list:
		var bank_slot: AmountBankSlot = action_amount_bank_slot_scene.instantiate()
		bank_slot.was_disabled.connect(update_disabled_bank_slots.bind(bank_slot))
		bank_slot.amount = amount
		action_amount_bank.add_child(bank_slot)
	are_amount_bank_slots_ready = true
	amount_bank_slots_readied.emit()

func update_disabled_bank_slots(bank_slot: AmountBankSlot) -> void:
	disabled_bank_slots.append(bank_slot)
	if all_disabled:
		all_actions_assigned.emit()
