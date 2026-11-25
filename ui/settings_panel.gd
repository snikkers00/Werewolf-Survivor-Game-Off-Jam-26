extends Panel

signal closed

@onready var master_slider: HSlider = %MasterSlider
@onready var master_value: Label = %MasterValue
@onready var music_slider: HSlider = %MusicSlider
@onready var music_value: Label = %MusicValue
@onready var sfx_slider: HSlider = %SFXSlider
@onready var sfx_value: Label = %SFXValue
@onready var fullscreen_check: CheckButton = %FullscreenCheck
@onready var back_button: Button = %BackButton


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	master_slider.value_changed.connect(_on_volume_changed.bind("Master", master_value))
	music_slider.value_changed.connect(_on_volume_changed.bind("BGM", music_value))
	sfx_slider.value_changed.connect(_on_volume_changed.bind("SFX", sfx_value))
	master_slider.drag_ended.connect(_on_slider_drag_ended)
	music_slider.drag_ended.connect(_on_slider_drag_ended)
	sfx_slider.drag_ended.connect(_on_slider_drag_ended)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	back_button.pressed.connect(_close)
	_sync_ui()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		_close()


func _on_visibility_changed() -> void:
	if visible:
		_sync_ui()
		back_button.grab_focus()
	else:
		AudioManager.save_settings()


func _sync_ui() -> void:
	master_slider.set_value_no_signal(AudioManager.volumes["Master"])
	music_slider.set_value_no_signal(AudioManager.volumes["BGM"])
	sfx_slider.set_value_no_signal(AudioManager.volumes["SFX"])
	master_value.text = _pct(AudioManager.volumes["Master"])
	music_value.text = _pct(AudioManager.volumes["BGM"])
	sfx_value.text = _pct(AudioManager.volumes["SFX"])
	var is_fs := DisplayServer.window_get_mode() in [
		DisplayServer.WINDOW_MODE_FULLSCREEN,
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
	]
	fullscreen_check.set_pressed_no_signal(is_fs)


func _on_volume_changed(value: float, bus_name: String, label: Label) -> void:
	label.text = _pct(value)
	AudioManager.set_volume(bus_name, value, false)


func _on_slider_drag_ended(_value_changed: bool) -> void:
	AudioManager.play_sound("click")
	AudioManager.save_settings()


func _on_fullscreen_toggled(enabled: bool) -> void:
	AudioManager.play_sound("click")
	AudioManager.set_fullscreen(enabled)


func _close() -> void:
	AudioManager.play_sound("click")
	hide()
	closed.emit()


func _pct(value: float) -> String:
	return str(roundi(value * 100.0)) + "%"
