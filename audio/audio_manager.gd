extends Node

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_player.play()
	stored_playback = sfx_player.get_stream_playback()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func play_sound(sound_name: String) -> void:
	if ui_sounds.has(sound_name):
		stored_playback.play_stream(ui_sounds[sound_name])
	else:
		print("Sound " + sound_name + " not found in ui_sounds dictionary")
