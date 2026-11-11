extends UpgradableStructure

@export var base_exp_tick_rate : float = 1.0

func level_up() -> void:
	super.level_up()
	base_exp_tick_rate *= 1.5
	print("tick rate increased to " + str(base_exp_tick_rate))