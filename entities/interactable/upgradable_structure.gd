extends Node3D
class_name UpgradableStructure

@export var structure_name : String

enum structure_cost_type {
	WOOD,
	STONE,
	WOOD_AND_STONE
}

@export var cost_type : structure_cost_type
@export var starting_level : int
@export var current_level : int

@export var upgrade_cost_wood : int
@export var upgrade_cost_stone : int

@onready var structure_model : Node3D = get_tree().get_first_node_in_group("StructureModel")
@onready var structure_interact_label : Label3D = %StructureLabel3D
@onready var interaction_area : Area3D = %InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = starting_level
	structure_interact_label.visible = false
	update_structure_label()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and structure_interact_label.visible == true:
		level_up()


func level_up() -> void:
	if cost_type == structure_cost_type.WOOD:
		if Resources.check_spend_resource_success(Resources.ResourceType.WOOD, upgrade_cost_wood) == true:
			
			upgrade()
			print("Upgraded " + structure_name + " to level " + str(current_level))
			update_structure_label()
		elif Resources.check_spend_resource_success(Resources.ResourceType.WOOD, upgrade_cost_wood) == false:
			print("Not enough wood to upgrade " + structure_name)
			
	elif cost_type == structure_cost_type.STONE:
		if Resources.check_spend_resource_success(Resources.ResourceType.STONE, upgrade_cost_stone) == true:
			
			upgrade()
			print("Upgraded " + structure_name + " to level " + str(current_level))
			update_structure_label()
		elif Resources.check_spend_resource_success(Resources.ResourceType.STONE, upgrade_cost_stone) == false:
			print("Not enough stone to upgrade " + structure_name)
			
	elif cost_type == structure_cost_type.WOOD_AND_STONE:
		if Resources.check_spend_resource_success(Resources.ResourceType.WOOD, upgrade_cost_wood) == true and Resources.check_spend_resource_success(Resources.ResourceType.STONE, upgrade_cost_stone) == true:
			
			upgrade()
			print("Upgraded " + structure_name + " to level " + str(current_level))
			update_structure_label()
		elif Resources.check_spend_resource_success(Resources.ResourceType.WOOD, upgrade_cost_wood) == false or Resources.check_spend_resource_success(Resources.ResourceType.STONE, upgrade_cost_stone) == false:
			print("Not enough resources to upgrade " + structure_name)


func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		update_structure_label()
		structure_interact_label.visible = true


func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		structure_interact_label.visible = false

func upgrade() -> void:
	current_level += 1
	interaction_area.scale *= 1.5
	var get_feedback = create_tween()
	get_feedback.tween_property(structure_model, "scale", structure_model.scale * 1.15, 0.1)
	get_feedback.tween_property(structure_model, "scale", structure_model.scale, 0.1)

func update_structure_label() -> void:
	structure_interact_label.text = (structure_name + " Level: " + str(current_level) + "\nCost: " + str(upgrade_cost_wood) + " Wood, " + str(upgrade_cost_stone) + " Stone")
	structure_interact_label.text += "\nPress E to upgrade " + structure_name + " to Level " + str(current_level + 1)
