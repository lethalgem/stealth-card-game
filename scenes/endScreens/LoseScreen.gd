extends Node2D


func _ready():
	var tween = create_tween()
	tween.tween_property(%LoseFadeInRect, "modulate:a", 0, 1).set_ease(Tween.EASE_OUT)


func _on_button_pressed():
	var tween = create_tween()
	tween.tween_property(%LoseFadeInRect, "modulate:a", 1, 1).set_ease(Tween.EASE_IN)
	tween.connect("finished", fade_finished)


func fade_finished():
	get_tree().change_scene_to_file("res://scenes/game/Game.tscn")
