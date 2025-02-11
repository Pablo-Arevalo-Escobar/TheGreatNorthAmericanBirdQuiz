extends Control

var stopped_time = 0.0

@onready
var audio_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.play_event.connect(play_audio)
	SignalBus.pause_event.connect(pause_audio)
	SignalBus.forward_event.connect(forward_audio)
	SignalBus.rewind_event.connect(rewind_audio)
	pass # Replace with function body.

func play_audio() -> void:
	audio_player.pitch_scale = 1.0
	audio_player.play(stopped_time)
	pass
func pause_audio() -> void:
	stopped_time = audio_player.get_playback_position()
	audio_player.stop()
	pass
func forward_audio() -> void:
	audio_player.pitch_scale = 1.5
func rewind_audio() -> void:
	audio_player.pitch_scale = 0.5
