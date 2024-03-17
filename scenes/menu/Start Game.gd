extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the button's "pressed" signal to this script's "_on_Button_pressed" method
	connect("pressed",_on_pressed)

func _on_pressed():
	print("Button pressed")
	# Get the AudioStreamPlayer node
	var audio_player = get_node("VBoxContainer/Start Game/Perfect")  # Replace "YourScenePath" with the actual path to your AudioStreamPlayer node

	# Check if the audio player exists and is loaded with a sound
	if audio_player and audio_player.stream:
		# Play the sound
		audio_player.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


