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
