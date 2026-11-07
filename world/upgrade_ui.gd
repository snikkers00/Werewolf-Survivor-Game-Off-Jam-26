extends Control

@export var all_upgrades : Array[Upgrade]
@onready var upgrades: HBoxContainer = %Upgrades

var upgrade1 : Upgrade
var upgrade2 : Upgrade
var upgrade3 : Upgrade

func check_and_update_upgrades():
	var checked_upgrades = all_upgrades.duplicate()
	checked_upgrades.shuffle()
	for u in range(3):
		var upgrade = checked_upgrades[u]
		var buttons = upgrades.get_children()
		var button = buttons[u]
	

		button.get_node("MarginContainer/UpgradeNameLabel").text = upgrade.name
		button.get_node("MarginContainer/UpgradeDescLabel").text = upgrade.description
		button.get_node("MarginContainer/UpgradeIcon").texture = upgrade.icon

	upgrade1 = checked_upgrades[0]
	upgrade2 = checked_upgrades[1]
	upgrade3 = checked_upgrades[2]

func apply_upgrade(upgrade):
	EventsBus.upgrade_selected.emit(upgrade)

func _on_upgrade_button_1_pressed() -> void:
	apply_upgrade(upgrade1)
	visible = false
	get_tree().paused = false
	print("Upgrade applied: " + upgrade1.name)


func _on_upgrade_button_2_pressed() -> void:
	apply_upgrade(upgrade2)
	visible = false
	get_tree().paused = false
	print("Upgrade applied: " + upgrade2.name)



func _on_upgrade_button_3_pressed() -> void:
	apply_upgrade(upgrade3)
	visible = false
	get_tree().paused = false
	print("Upgrade applied: " + upgrade3.name)
