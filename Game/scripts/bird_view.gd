extends Control

var display
@export var secret_texture : Texture
@export var fail_texture : Texture
@export var win_texture : Texture

# Updates the view 
func update(bird) -> void:
	display.set_texture(bird.sprite)
	
func end_game(is_win : bool) -> void:
	if is_win:
		display.set_texture(win_texture)
	else:
		display.set_texture(fail_texture)
	
func toggle_screen(is_on : bool) -> void:
	$BirdView/Screen.visible = is_on 
	$BirdView/DisplayFrame/PointLight2D.visible = is_on

func toggle_secret_screen(is_on : bool) -> void:
	display.set_texture(secret_texture)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_screen(false)
	display = $BirdView/Screen/Display
	var display_switch_node = get_node("../Switches/bird_switch/switch")
	assert(display_switch_node)
	display_switch_node.switch_on_event.connect(func(): toggle_screen(true))
	display_switch_node.switch_off_event.connect(func(): toggle_screen(false) )
	
	var secret_switch = get_node("../Switches/secret_switch/switch")
	assert(secret_switch)
	secret_switch.switch_on_event.connect(func(): toggle_secret_screen(true))
	secret_switch.switch_off_event.connect(func(): toggle_secret_screen(false))
	
	SignalBus.game_end_good_event.connect(func(): end_game(true))
	SignalBus.game_end_bad_event.connect(func(): end_game(false))
