extends UpgradableStructure

var base_healing_tick_rate: float = 1.0
var campfire_light : OmniLight3D

func _ready() -> void:
	super._ready()
	if structure_model:
		campfire_light = structure_model.get_node("CampfireLight")

func level_up() -> void:
	super.level_up()
	if current_level > 1:
		base_healing_tick_rate *= 1.5
		print("healing tick rate increased to " + str(base_healing_tick_rate))#
		campfire_light.light_energy *= 1.5
		campfire_light.range *= 1.5

func activate_structure() -> void:
	if current_level > 0:
		var player = get_tree().get_first_node_in_group("Player")
		if player.health.health < player.health.max_health:
			player.health.health += base_healing_tick_rate
			player.update_health_ui()
			print("Healing player for " + str(base_healing_tick_rate) + " health")
