extends Control

@onready var world_handler : Node3D = %WorldHandler

@onready var world_timer : Timer = %Day_NightTimer
@onready var world_progress: ProgressBar = %WorldProgress
@onready var day_night_label : Label = %Day_NightLabel

func _ready():
	world_progress.max_value = world_timer.wait_time
	day_night_label.text = "Day"
	Resources.wood_label = %WoodLabel
	Resources.stone_label = %StoneLabel
	world_progress.max_value = int(world_timer.wait_time)
	EventsBus.phase_changed.connect(_on_phase_changed)
	

func _process(_delta):
	world_progress.max_value = int(world_timer.wait_time)
	world_progress.value = int(world_timer.time_left)

func _on_phase_changed(is_night: bool) -> void:
	if is_night:
		day_night_label.text = "Night:" + str(RunStats.days_lasted + 1)
	else:
		day_night_label.text = "Day:" + str(RunStats.days_lasted + 1)
