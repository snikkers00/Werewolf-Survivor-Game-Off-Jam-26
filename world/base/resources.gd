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

func reset_resources() -> void:
	current_wood = 0
	current_stone = 0
	resource_rate = 1.0
	update_resource_ui()


func gain_resource(resource_type : ResourceType, amount : int) -> void:
	if resource_type == ResourceType.WOOD:
		current_wood += amount * resource_rate
		print("Gained wood")
		RunStats.resources_gathered += amount * resource_rate
		
	elif resource_type == ResourceType.STONE:
		current_stone += amount * resource_rate
		print("Gained stone")
		RunStats.resources_gathered += amount * resource_rate
		
	update_resource_ui()
		

func update_resource_ui() -> void:
	if wood_label:
		wood_label.text = ": " + str(current_wood)
	if stone_label:
		stone_label.text = ": " + str(current_stone)


func try_spend(wood: int, stone: int) -> bool:
	if current_wood < wood or current_stone < stone:
		return false
	current_wood -= wood
	current_stone -= stone
	update_resource_ui()
	return true