extends Panel

@onready var endlabel : Label = $EndLabel
@onready var stats_label : RichTextLabel = $StatsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventsBus.boss_defeated.connect(_on_game_win)

func _on_game_win():
	get_tree().paused = true
	endlabel.text = "You Win!"
	stats_label.text = "Days Lasted: " + str(RunStats.days_lasted) + "\n" + "Resources Gathered: " + str(RunStats.resources_gathered) + "\n" + "Knowledge Gained: " + str(RunStats.total_exp_gained) + "\n" + "Enemies Killed: " + str(RunStats.enemies_killed)
	visible = true



func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")


func _on_close_game_button_pressed() -> void:
	get_tree().quit()
