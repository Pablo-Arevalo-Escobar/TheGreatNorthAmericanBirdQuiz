extends Control

var button_left
var button_right
var text_label

# Updates the view 
func update_score(new_score) -> void:
	text_label.text = new_score
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_label = $Score
	button_left = $Left
	button_right = $Right
