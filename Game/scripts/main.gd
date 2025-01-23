extends Control

# Bird
# name   : 
# audio  :
# sprite :  
var birds 

# Game logic
var score = 0
var curr_index = 0 
var guessed_set := {}

# Views
var map_view
var bird_view
var name_list
var score_view

# Audio
var audio_player : AudioStreamPlayer

func get_bird_data():
	if birds == null:
		birds = read_bird_data()
	return birds
	
func load_image(sprite_name):
	var image = Image.new()
	var err = image.load("res://img/" + sprite_name)
	if err != OK:
		print("Failure")
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture
	
func load_audio(audio_name):
	return load("res://audio/" + audio_name) as AudioStream

func read_bird_data():
	var file = FileAccess.open("res://birdData.json", FileAccess.READ)
	
	var json = JSON.new()
	var birds_string = FileAccess.get_file_as_string("res://birdData.json")
	var birds_dict = JSON.parse_string(birds_string)["birds"]
	
	for bird in birds_dict:
		bird.sprite = load_image(bird.sprite)
		bird.audio = load_audio(bird.audio) 
		bird.area = load_image(bird.area)
		
	return birds_dict


func display(bird_index) -> void:
	# Update both display's based on the bird index
	map_view.update(birds[bird_index])
	bird_view.update(birds[bird_index])
	
# Updates the currently selected bird to guess
func change_index(direction):
	print(len(guessed_set) , " VS ", len(birds))
	if len(guessed_set) == len(birds):
		return
	
	curr_index = (curr_index+direction)%len(birds)
	if curr_index < 0:
			curr_index = len(birds)-1
			
	while curr_index in guessed_set:
		curr_index = (curr_index+direction)%len(birds)
		if curr_index < 0:
			curr_index = len(birds)-1
			
	display(curr_index)
	play_audio(curr_index)
	
func play_audio(bird_index) -> void:
	audio_player.stream = birds[bird_index].audio
	audio_player.play(0)
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			guess()

# Checks if the currently selected bird matches the guess
func guess():
	if !name_list.is_anything_selected():
		return
		
	if score == len(birds):
		print("DONE-SO")
		return
		
	
	var bird_guess = name_list.get_item_text(name_list.get_selected_items()[0])
	if birds[curr_index].name == bird_guess :
		score += 1
		print("TRUE", score, "/", len(birds))
	else:
		print("FALSE")
	
	# Add the current index to the guessed set..
	guessed_set[curr_index] = {}
	update_score_view()
	self.change_index(1)
	 
func update_score_view():
	var curr_score = str(score) + "/" + str(len(birds))
	score_view.update_score(curr_score)
	
func _ready() -> void:
	map_view = $MapView 
	bird_view = $BirdView
	score_view = $ScoreView
	
	audio_player = bird_view.get_node("SubViewportContainer/SubViewport/ShowSpectrum/AudioStreamPlayer")
	
	# Subscribe to the buttons 
	score_view.button_right.pressed.connect(self.change_index.bind(1))
	score_view.button_left.pressed.connect(self.change_index.bind(-1))
	
	# Initialize the name list
	birds = get_bird_data()
	name_list = get_node("NameView/ItemList")
	var i = 0
	for bird in birds:
		i += 1
		name_list.add_item(bird.name)
		
	display(curr_index)
	play_audio(curr_index)
	update_score_view()
