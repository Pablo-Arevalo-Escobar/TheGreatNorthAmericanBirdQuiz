extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.play_event.connect(play_cassete)
	SignalBus.pause_event.connect(pause_cassete)
	SignalBus.forward_event.connect(forward_cassete)
	SignalBus.rewind_event.connect(reverse_cassete)
	pass # Replace with function body.

func play_cassete() -> void:
	play("default",1.0)
func forward_cassete() -> void:
	play("default",2.5)
func reverse_cassete() -> void:
	play("default",0.5)
func pause_cassete() -> void:
	stop()
