extends Control

var overlay : ColorRect
var button : AnimatedSprite2D
var in_anim : bool
var parent

@onready
var audio : AudioStreamPlayer

func _ready() -> void:
	button = get_node("button")
	overlay = get_node("Overlay")
	audio = get_parent().get_node("AudioButtonPlayer")
	audio.finished.connect(on_button_pressed)
	in_anim = false
	overlay.visible = false

func _on_mouse_entered() -> void:
	overlay.visible = true

func _on_mouse_exited() -> void:
	overlay.visible = false
	
func on_button_pressed() -> void:
	if !in_anim:
		return
	button.pause()
	audio.stop()
	button.frame = 0
	in_anim = false
	SignalBus.button_pressed.emit(self.name)
	
func toggle_button() -> void:
	if in_anim:
		return
	in_anim = true
	button.play("default")
	audio.play()	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:  # True when the button is pressed, False when released
			if event.button_index == MOUSE_BUTTON_LEFT:
				toggle_button()
