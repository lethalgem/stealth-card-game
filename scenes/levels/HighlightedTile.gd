extends Area2D


func _ready():
	start_highlighting()


func start_highlighting():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, .5)
	tween.connect("finished", on_opaque_tween_finished)


func on_opaque_tween_finished():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, .5)
	tween.connect("finished", on_transparent_tween_finished)


func on_transparent_tween_finished():
	start_highlighting()
