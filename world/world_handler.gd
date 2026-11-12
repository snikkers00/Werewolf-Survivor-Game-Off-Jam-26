extends Node3D

@onready var world_light : DirectionalLight3D = %WorldLight
@onready var day_night_timer : Timer = %Day_NightTimer
var is_night : bool = false

@export var day_length : float
@export var night_length : float

func _ready() -> void:
	EventsBus.reset_to_day.connect(reset_to_day)
	day_night_timer.start(day_length)
	print("timer set to " + str(day_night_timer.wait_time))

func _on_timer_timeout():
	is_night = not is_night
	EventsBus.phase_changed.emit(is_night)
	if is_night == true:
		create_tween().tween_property(world_light, "light_color" , Color.BLUE, 1.5)
		day_night_timer.start(night_length)
		print("timer set to " + str(day_night_timer.wait_time))
	
	elif is_night == false:
		create_tween().tween_property(world_light, "light_color" , Color.ORANGE_RED, 1.5)
		RunStats.days_lasted += 1
		day_night_timer.start(day_length)
		print("timer set to " + str(day_night_timer.wait_time))

func reset_to_day(player_died : bool) -> void:
	is_night = false
	EventsBus.phase_changed.emit(is_night)
	create_tween().tween_property(world_light, "light_color" , Color.ORANGE_RED, 1.5)
	day_night_timer.wait_time = day_length
	day_night_timer.start()
	print("timer set to " + str(day_night_timer.wait_time))
	