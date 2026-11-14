extends Node3D

@onready var day_light: DirectionalLight3D = %DayLight
@onready var night_light: DirectionalLight3D = %NightLight
@onready var day_night_timer: Timer = %Day_NightTimer
@onready var animator: AnimationPlayer = %NightCycleAnimationPlayer
var is_night: bool = false

@export var day_length: float
@export var night_length: float

var normalized_timer: float

func _ready() -> void:
	EventsBus.reset_to_day.connect(reset_to_day)
	day_night_timer.start(day_length)
	print("timer set to " + str(day_night_timer.wait_time))
	if is_night:
		set_night_lights()
	else:
		set_day_lights()

func _process(delta: float) -> void:
	normalized_timer = clampf((day_night_timer.get_time_left() / day_night_timer.wait_time), 0.0, 1.0)
	

func _on_timer_timeout():
	is_night = not is_night
	EventsBus.phase_changed.emit(is_night)
	if is_night == true:
		day_night_timer.start(night_length)
		set_night_lights()
		print("timer set to " + str(day_night_timer.wait_time))
	
	elif is_night == false:
		RunStats.days_lasted += 1
		day_night_timer.start(day_length)
		set_day_lights()
		print("timer set to " + str(day_night_timer.wait_time))

func reset_to_day(player_died: bool) -> void:
	is_night = false
	EventsBus.phase_changed.emit(is_night)
	
	day_night_timer.wait_time = day_length
	day_night_timer.start()
	set_day_lights()
	print("timer set to " + str(day_night_timer.wait_time))


func set_day_lights() -> void:
	animator.play("sunandmoonrotation")
	animator.seek(normalized_timer * animator.current_animation_length)
	create_tween().tween_property(day_light, "light_energy", 1.2, 1.5)
	create_tween().tween_property(night_light, "light_energy", 0, 1.5)

func set_night_lights() -> void:
	animator.play("sunandmoonrotation")
	animator.seek(normalized_timer * animator.current_animation_length)
	create_tween().tween_property(day_light, "light_energy", 0, 1.5)
	create_tween().tween_property(night_light, "light_energy", 0.3, 1.5)
