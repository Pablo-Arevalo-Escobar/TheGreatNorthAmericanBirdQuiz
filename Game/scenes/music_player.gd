extends Control

var stopped_time = 0.0
@export var secret_audio : AudioStream
	
@onready
var audio_player = $AudioBirdPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.play_event.connect(play_audio)
	SignalBus.pause_event.connect(pause_audio)
	SignalBus.forward_event.connect(forward_audio)
	SignalBus.rewind_event.connect(rewind_audio)
	SignalBus.bird_changed.connect(reset)

	var secret_switch = get_node("../../Switches/secret_switch/switch")
	assert(secret_switch)
	secret_switch.switch_on_event.connect(func(): toggle_secret_audio(true))
	secret_switch.switch_off_event.connect(func(): toggle_secret_audio(false))
	
func toggle_secret_audio(is_on : bool) -> void:
	reset()
	if is_on:
		audio_player.stream = secret_audio
		audio_player.volume_db = -10
		SignalBus.play_event.emit()
	else:
		SignalBus.pause_event.emit()
	
func reset() -> void:
	stopped_time = 0.0
	
func play_audio() -> void:
	audio_player.pitch_scale = 1.0
	audio_player.play(stopped_time)
	pass
func pause_audio() -> void:
	stopped_time = audio_player.get_playback_position()
	audio_player.stop()
	pass
func forward_audio() -> void:
	stopped_time = max(stopped_time,audio_player.get_playback_position())
	audio_player.pitch_scale = 1.5
	audio_player.play(stopped_time)
	
func rewind_audio() -> void:
	stopped_time = max(stopped_time,audio_player.get_playback_position())
	audio_player.pitch_scale = 0.5
	audio_player.play(stopped_time)
