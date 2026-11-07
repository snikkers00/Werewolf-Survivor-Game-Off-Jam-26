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


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	pass # Replace with function body.


func _on_close_game_button_pressed() -> void:
	get_tree().quit()
