extends UpgradableStructure

@export var base_exp_tick_rate : float = 1.0

func level_up() -> void:
	super.level_up()
	base_exp_tick_rate *= 1.5
	print("tick rate increased to " + str(base_exp_tick_rate))

func activate_structure() -> void:
	if current_level > 0:
		var player = get_tree().get_first_node_in_group("Player")
		player.gain_exp(base_exp_tick_rate)
		player.update_exp_ui()
		print("Gaining " + str(base_exp_tick_rate) + " experience")
