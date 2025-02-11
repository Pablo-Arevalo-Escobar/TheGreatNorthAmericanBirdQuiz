extends Control

var overlay : ColorRect
var button : AnimatedSprite2D
var at_rest : bool
var button_press : AudioListener2D
var parent
# Play the button press sound
func play_audio() -> void:
	button_press.play_audio()

func _ready() -> void:
	button = get_node("button")
	overlay = get_node("Overlay")
	at_rest = true
	overlay.visible = false
	
func reset() -> void:
	button.play("Rest")

func _on_mouse_entered() -> void:
	pass
	#overlay.visible = true

func _on_mouse_exited() -> void:
	overlay.visible = false
	
func toggle_button() -> void:
	SignalBus.button_pressed.emit(self.name)
	if at_rest:
		button.play("Pressed")
	else:
		button.play("Rest")
	at_rest = !at_rest

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:  # True when the button is pressed, False when released
			if event.button_index == MOUSE_BUTTON_LEFT:
				toggle_button()
