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
var game_over = false
var bird_order

# Views
var map_view
var bird_view
var name_list : ItemList
var score_view

# Audio
var audio_player : AudioStreamPlayer

func get_bird_data():
	if birds == null:
		birds = read_bird_data()
	return birds
	
func load_image(img_path):
	var image = Image.new()
	var err = image.load(img_path)
	if err != OK:
		print("Failure")
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture
	
func load_audio(audio_name):
	return load(audio_name) as AudioStream


func read_bird_data() -> Array:
	var birds_path = "res://birds/"
	var birds_list = []
	var dir = DirAccess.open(birds_path)

	if dir:
		dir.list_dir_begin()
		var bird_folder = dir.get_next()		
		while bird_folder != "":
			var bird_data = {}
			var bird_folder_path = birds_path + bird_folder + "/"

			if DirAccess.dir_exists_absolute(bird_folder_path):
				bird_data["name"] = bird_folder
				bird_data["sprite"] = load_image(bird_folder_path + "sprite.png")
				bird_data["audio"] = load_audio(bird_folder_path + "audio.mp3")
				bird_data["area"] = load_image(bird_folder_path + "overlay.png")
				
				birds_list.append(bird_data)
			
			bird_folder = dir.get_next()
	else:
		print("Error: Could not open birds directory.")

	birds_list.shuffle()
	
	bird_order = []
	for i in range(birds_list.size()):
		bird_order.append(i)
	
	bird_order.shuffle()
	return birds_list
	
func read_bird_datas():
	var file = FileAccess.open("res://birdData.json", FileAccess.READ)
	var json = JSON.new()
	var birds_string = FileAccess.get_file_as_string("res://birdData.json")
	var birds_dict = JSON.parse_string(birds_string)["birds"]
	
	for bird in birds_dict:
		bird.sprite = load_image("res://img/birds/" + bird.sprite)
		bird.area = load_image("res://img/overlays/" + bird.area)
		bird.audio = load_audio(bird.audio) 
		
	return birds_dict

func update() -> void:
	play_audio()
	display(bird_order[curr_index])
	update_score_view()

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
			
	update()
	
func play_audio() -> void:
	$AudioSwitch.play()
	audio_player.stop()
	audio_player.stream = birds[bird_order[curr_index]].audio
	SignalBus.bird_changed.emit()
	#audio_player.play()
func pause_audio() -> void:
	pass
	#audio_player.stop()
	
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER, KEY_KP_ENTER when !game_over:
				guess()
			KEY_E:
				change_index(1)
			KEY_Q:
				change_index(-1)
			KEY_R:
				get_tree().reload_current_scene()

# Function to end the game
func end_game():
	game_over = true
	if score == len(guessed_set):
		SignalBus.game_end_good_event.emit()
	else:
		SignalBus.game_end_bad_event.emit()

# Checks if the currently selected bird matches the guess
func guess():
	if !name_list.is_anything_selected():
		return
		
	var bird_guess = name_list.get_item_text(name_list.get_selected_items()[0])
	var guess_index = bird_order[curr_index]
	if birds[guess_index].name == bird_guess :
		score += 1
		# Set the text color to green
		name_list.set_item_custom_fg_color(guess_index,Color.GREEN)
		$AudioGuessRight.play()
		print("TRUE", score, "/", len(birds))
	else:
		# Set the text color to red
		name_list.set_item_custom_fg_color(guess_index,Color.RED)
		$AudioGuessWrong.play()
		print("FALSE")
	
	name_list.set_item_selectable(guess_index, false)
	
	# Add the current index to the guessed set..
	guessed_set[curr_index] = {}
	update_score_view()
	self.change_index(1)
	
	if len(guessed_set) == len(birds):
		end_game()
	 
func update_score_view():
	score_view.update_score(str(score))
	
func _ready() -> void:
	map_view = $MapView 
	bird_view = $BirdView
	score_view = $BirdView/BirdView/Screen/ScoreView
	
	audio_player = bird_view.get_node("MusicPlayer/AudioBirdPlayer")
		
	# Initialize the name list
	birds = get_bird_data()
	name_list = get_node("NameView/ItemList")
	var i = 0
	for bird in birds:
		i += 1
		name_list.add_item(bird.name)
	
	update()
	map_view.toggle_screen(false)
	name_list.visible = false
