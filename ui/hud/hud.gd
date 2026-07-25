extends Control
class_name Hud

@export var action_amount_bank_slot_scene: PackedScene

@export var action_amount_bank: HBoxContainer
@export var action_slots_container: HBoxContainer
@export var timer : Label 


func create_amount_bank_slots(amount_list: PackedInt32Array) -> void:
	for amount in amount_list:
		var bank_slot: AmountBankSlot = action_amount_bank_slot_scene.instantiate()
		bank_slot.amount = amount
		action_amount_bank.add_child(bank_slot)
