extends Control

@onready var world_handler : Node3D = %WorldHandler

@onready var world_timer : Timer = %Day_NightTimer
@onready var world_progress: ProgressBar = %WorldProgress
@onready var day_night_label : Label = %Day_NightLabel

func _ready():
	world_progress.max_value = world_timer.wait_time
	day_night_label.text = "Day"

func _process(_delta):
	world_progress.value = int(world_timer.time_left)
	
	if world_handler.is_night == true:
		day_night_label.text = "Night"
	elif  world_handler.is_night == false:
		day_night_label.text = "Day"
