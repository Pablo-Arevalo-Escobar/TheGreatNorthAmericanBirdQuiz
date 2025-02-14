extends Control

var map_display : AnimatedSprite2D
var map_overlay : Sprite2D
var secret_switch

var secret_screen 
var win_screen
var bad_screen

func load_image(img_path):
	var image = Image.new()
	var err = image.load(img_path)
	if err != OK:
		print("Failure")
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture
	
# Enable/Disable the screen
func toggle_screen(is_on : bool):
	$SubViewportContainer/PointLight2D.visible = is_on
	$SubViewportContainer/SubViewport/MapDisplay.visible = is_on 
	$SubViewportContainer/SubViewport/Overlay.visible = is_on
	$SubViewportContainer/SubViewport/CanvasLayer/ColorRect.material.set_shader_parameter("is_on", int(is_on))
	
	if is_on:
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
	
func toggle_secret_screen(is_on : bool):
	if is_on:
		map_overlay.texture = secret_screen
		map_overlay.offset = Vector2(-147.95, -158.03)
		map_overlay.scale = Vector2(1.5,1.5)
	else:
		map_overlay.offset = Vector2(0, 0)
		map_overlay.scale = Vector2(1,1)
	# offset x -147.95 y -158.03
	# scale 1.5 1.5
# Updates the view 
func update(bird) -> void:
	print("Map View : ", bird)
	map_overlay.texture = bird.area
	map_overlay.modulate =  Color(max(randf(), 0.5), 0.0, max(randf(), 0.5), 0.55)
	
func end_game(good : bool) -> void:
	var texture
	if good:
		texture = win_screen
		secret_switch.enable()
	else:
		texture = bad_screen
		$AudioStreamPlayer.volume_db = -10
		get_node("../CanvasModulate").color = Color.from_string("c82741", Color.RED)
		
	map_overlay.texture = texture
	map_overlay.modulate = Color(1.0,1.0,1.0,1.0)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.finished.connect(func(): if $SubViewportContainer/SubViewport/MapDisplay.visible: $AudioStreamPlayer.play())
	
	secret_screen = load_image("res://secret/Clara/overlay.png")
	win_screen = load_image("res://img/endscreen_happy.png")
	bad_screen = load_image("res://img/endscreen_mad.png")
	
	
	map_display = get_node("SubViewportContainer/SubViewport/MapDisplay")
	map_overlay = get_node("SubViewportContainer/SubViewport/Overlay")
	var tv_switch_node = get_node("../Switches/map_switch/switch")
	secret_switch = get_node("../Switches/secret_switch/switch")
	assert(tv_switch_node)
	assert(secret_switch)
	tv_switch_node.switch_on_event.connect(func(): toggle_screen(true))
	tv_switch_node.switch_off_event.connect(func(): toggle_screen(false) )
	
	secret_switch.switch_on_event.connect(func(): toggle_secret_screen(true))
	secret_switch.switch_off_event.connect(func(): toggle_secret_screen(false))
	
	SignalBus.game_end_good_event.connect(func(): end_game(true))
	SignalBus.game_end_bad_event.connect(func(): end_game(false))
