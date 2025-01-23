extends Control

var map_display : AnimatedSprite2D
var map_overlay : Sprite2D

# Updates the view 
func update(bird) -> void:
	print("Map View : ", bird)
	map_overlay.texture = bird.area
	map_overlay.modulate =  Color(randf(), randf(), randf(), 0.6)
	pass 
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_display = get_node("SubViewportContainer/SubViewport/MapDisplay")
	map_overlay = get_node("SubViewportContainer/SubViewport/Overlay")
	pass # Replace with function body.
