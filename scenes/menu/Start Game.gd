extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", _on_pressed)


func _on_pressed():
	%PerfectAudioPlayer.play()
