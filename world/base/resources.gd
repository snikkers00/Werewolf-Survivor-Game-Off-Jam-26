extends Node

enum ResourceType {
	WOOD,
	STONE
}

@onready var wood_label : Label
@onready var stone_label : Label

var resource_rate : float = 1.0
var current_wood : int
var current_stone : int

func gain_resource(resource_type : ResourceType, amount : int) -> void:
	if resource_type == ResourceType.WOOD:
		current_wood += amount * resource_rate
		print("Gained wood")
		
	elif resource_type == ResourceType.STONE:
		current_stone += amount * resource_rate
		print("Gained stone")
		
	update_resource_ui()
		

func update_resource_ui() -> void:
	wood_label.text = ": " + str(current_wood)
	stone_label.text = ": " + str(current_stone)


func check_spend_resource_success(resource_type : ResourceType, amount : int) -> bool:
	if resource_type == ResourceType.WOOD:
		if current_wood >= amount:
			current_wood -= amount
			update_resource_ui()
			return true
		else:
			print("Not enough wood")
			return false
			
	elif resource_type == ResourceType.STONE:
		if current_stone >= amount:
			current_stone -= amount
			update_resource_ui()
			return true
		else:
			print("Not enough stone")
			return false
	else:
		print("Invalid resource types submitted")
		return false