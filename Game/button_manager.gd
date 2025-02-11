extends Node

func _ready():
	SignalBus.button_pressed.connect(button_event)
	
func button_event(name : StringName):
	match name:
		"Play":
			SignalBus.play_event.emit()
		"Rewind":
			SignalBus.rewind_event.emit()
		"Forward":
			SignalBus.forward_event.emit()
		"Pause":
			SignalBus.pause_event.emit()
