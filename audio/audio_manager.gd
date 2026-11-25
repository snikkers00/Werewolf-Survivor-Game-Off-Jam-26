extends Node

const SETTINGS_PATH := "user://settings.cfg"
const VOLUME_BUSES := ["Master", "BGM", "SFX"]

@export var default_music : AudioStreamWAV
@export var ui_sounds : Dictionary[String, AudioStream] = {
	"click" : null,
	"select" : null,
	"level_up" : null,
	"gain_exp" : null,
	"spend_resource" : null,
	"becomes_day" : null,
	"becomes_night" : null,
	"game_over" : null,
	"game_win" : null,
	"game_unpause" : null,
	"game_pause" : null,
}

@onready var sfx_player : AudioStreamPlayer = %UISFX

var stored_playback : AudioStreamPlaybackPolyphonic
var volumes : Dictionary = {"Master": 1.0, "BGM": 1.0, "SFX": 1.0}
var fullscreen : bool = false
var _base_bus_db : Dictionary = {}


func _ready() -> void:
	for bus_name in VOLUME_BUSES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx != -1:
			_base_bus_db[bus_name] = AudioServer.get_bus_volume_db(idx)
	load_settings()
	sfx_player.play()
	stored_playback = sfx_player.get_stream_playback()


func play_sound(sound_name: String) -> void:
	var stream: AudioStream = ui_sounds.get(sound_name)
	if stream and stored_playback:
		stored_playback.play_stream(stream)


func set_volume(bus_name: String, value: float, save: bool = true) -> void:
	value = clampf(value, 0.0, 1.0)
	volumes[bus_name] = value
	var idx := AudioServer.get_bus_index(bus_name)
	if idx != -1:
		AudioServer.set_bus_mute(idx, value <= 0.001)
		if value > 0.001:
			AudioServer.set_bus_volume_db(idx, _base_bus_db.get(bus_name, 0.0) + linear_to_db(value))
	if save:
		save_settings()


func set_fullscreen(enabled: bool, save: bool = true) -> void:
	fullscreen = enabled
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED
	if DisplayServer.window_get_mode() != mode:
		DisplayServer.window_set_mode(mode)
	if save:
		save_settings()


func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return
	for bus_name in VOLUME_BUSES:
		set_volume(bus_name, float(cfg.get_value("audio", bus_name, 1.0)), false)
	fullscreen = bool(cfg.get_value("display", "fullscreen", false))
	if fullscreen and not OS.has_feature("web"):
		set_fullscreen(true, false)


func save_settings() -> void:
	var cfg := ConfigFile.new()
	for bus_name in VOLUME_BUSES:
		cfg.set_value("audio", bus_name, volumes[bus_name])
	cfg.set_value("display", "fullscreen", fullscreen)
	cfg.save(SETTINGS_PATH)
