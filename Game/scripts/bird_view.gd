extends Control

var display
# Updates the view 
func update(bird) -> void:
	display.set_texture(bird.sprite)
	pass 
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display = self.get_child(0)
	pass # Replace with function body.
