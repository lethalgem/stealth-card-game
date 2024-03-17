extends Control

@onready var music_bus = AudioServer.get_bus_index("GameMusic")
@onready var sound_bus = AudioServer.get_bus_index("GameSoundEffects")


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_mute(music_bus, true)
	AudioServer.set_bus_mute(sound_bus, true)


func _on_quit_game_pressed():
	get_tree().quit()


func _on_options_pressed():
	pass  # Replace with function body.


func _on_start_game_pressed():
	%PerfectAudioPlayer.play()
	var tween = create_tween()
	tween.tween_property(%FadeRect, "modulate:a", 1, 0.4).set_ease(Tween.EASE_IN)


func _on_perfect_audio_player_finished():
	get_tree().change_scene_to_file("res://scenes/game/Game.tscn")
	AudioServer.set_bus_mute(music_bus, false)
	AudioServer.set_bus_mute(sound_bus, false)
