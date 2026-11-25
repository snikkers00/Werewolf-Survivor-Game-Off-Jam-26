extends CanvasLayer

@onready var pause_panel: Panel = $PanelPanel
@onready var settings_panel: Panel = $SettingsPanel


func _ready() -> void:
	pause_panel.hide()
	settings_panel.hide()
	settings_panel.closed.connect(pause_panel.show)


func _unhandled_input(event: InputEvent) -> void:
	if get_parent().process_mode == Node.PROCESS_MODE_DISABLED:
		return
	if event.is_action_pressed("pause"):
		if get_tree().paused and not pause_panel.visible:
			return
		get_viewport().set_input_as_handled()
		_set_paused(not get_tree().paused)


func _set_paused(paused: bool) -> void:
	AudioManager.play_sound("click")
	get_tree().paused = paused
	pause_panel.visible = paused
	if not paused:
		settings_panel.hide()


func _on_resume_button_pressed() -> void:
	_set_paused(false)


func _on_settings_button_pressed() -> void:
	AudioManager.play_sound("click")
	pause_panel.hide()
	settings_panel.show()


func _on_restart_button_pressed() -> void:
	AudioManager.play_sound("click")
	RunStats.reset_stats()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	AudioManager.play_sound("click")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")


func _on_close_game_button_pressed() -> void:
	get_tree().quit()
