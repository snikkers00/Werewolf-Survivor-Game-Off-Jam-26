extends Node3D

@onready var world_light : DirectionalLight3D = %WorldLight
var is_night : bool = false

func _on_timer_timeout():
	is_night = not is_night
	EventsBus.phase_changed.emit(is_night)
	if is_night == true:
		create_tween().tween_property(world_light, "light_color" , Color.BLUE, 1.5)
	
	elif is_night == false:
		create_tween().tween_property(world_light, "light_color" , Color.ORANGE_RED, 1.5)
