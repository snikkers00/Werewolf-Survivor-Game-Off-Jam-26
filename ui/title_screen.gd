extends Control

@onready var world: Node3D = %MainWorld
@onready var menu_cam: Camera3D = get_node_or_null("MenuCamera")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	world.process_mode = Node.PROCESS_MODE_DISABLED
	world.get_node("UILayer").hide()
	world.get_node("%IntroLabel").hide()
	world.get_node("%DayLight").light_energy = 1.2
	world.get_node("%NightLight").light_energy = 0.0
	world.get_node("Entities/PlayerCharacter/HumanSprite").process_mode = Node.PROCESS_MODE_PAUSABLE
	if menu_cam:
		menu_cam.make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	AudioManager.play_sound("click")
	RunStats.reset_stats()
	get_tree().change_scene_to_file("res://world/main_world.tscn")


func _on_options_button_pressed() -> void:
	AudioManager.play_sound("click")
	%SettingsPanel.show()


func _on_close_game_button_pressed() -> void:
	get_tree().quit()
