extends Node
@export_range(0,10) var text_speed : float = 0.0015
@export_range(0,10) var text_delay : float = 1.0
var secret_mode : bool = false

func display_text(is_on : bool) -> void:
	$ItemList.visible = !is_on 
	$TextDisplay.visible = is_on
	set_process(is_on)
	secret_mode = is_on

func toggle_list(is_on : bool) -> void:
	if secret_mode :
		return
	$ItemList.visible = is_on

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var secret_switch = get_node("../Switches/secret_switch/switch")
	assert(secret_switch)
	secret_switch.switch_on_event.connect(func(): display_text(true))
	secret_switch.switch_off_event.connect(func(): display_text(false))
	
		# Subscribe to the buttons 
	var tv_switch_node = get_node("../Switches/map_switch/switch")
	assert(tv_switch_node)
	tv_switch_node.switch_on_event.connect(func():toggle_list(true))
	tv_switch_node.switch_off_event.connect(func():toggle_list(false))
	
	$TextDisplay.visible_ratio = 0.0
	set_process(false)

func _process(delta_time) -> void:
	if text_delay > 0:
		text_delay -= delta_time
		return
	
	if $TextDisplay.visible_ratio >= 1:
		set_process(false)
	$TextDisplay.visible_ratio += text_speed / 10
	
	#$Audio.stop()
	var char_index = $TextDisplay.visible_characters
	assert(len($TextDisplay.text) > char_index)
	var sound_char = $TextDisplay.text[char_index] != ' ' and $TextDisplay.text[char_index] != '\t'
	
	if !$Audio.playing and sound_char:		
		$Audio.play()
		
	
