class_name BaseCardVisual

extends Node2D

@export var cardTitle: Label

var is_hovered: bool = false
var starting_z_index: int


func _ready():
	starting_z_index = z_index


func _process(delta):
	if is_hovered:
		z_index = 100
	else:
		z_index = 0


func applyTitle(title: String):
	cardTitle.text = title


func _on_area_2d_mouse_entered():
	print("test")
	is_hovered = true


func _on_area_2d_mouse_exited():
	is_hovered = false
