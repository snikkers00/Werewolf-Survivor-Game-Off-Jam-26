extends Node

enum ResourceType {
	WOOD,
	STONE
}

var resource_rate : float = 1.0
var current_wood : int
var current_stone : int

func gain_resource(resource_type : ResourceType, amount : int) -> void:
	if resource_type == ResourceType.WOOD:
		current_wood += amount * resource_rate
		
	elif resource_type == ResourceType.STONE:
		current_stone += amount * resource_rate
		