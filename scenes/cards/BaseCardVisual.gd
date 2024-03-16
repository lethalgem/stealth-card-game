class_name BaseCardVisual

extends Node2D

@export var cardTitle: Label
@export var parent_card: Card

signal just_grabbed(card: Card)
signal just_dropped(card: Card)

var is_hovered: bool = false
var is_grabbed: bool = false
var is_interactable: bool = true
var starting_z_index: int
var overlapping_bodies = []


func _ready():
	starting_z_index = z_index


func _process(delta):
	if is_grabbed:
		parent_card.global_position = get_viewport().get_mouse_position()
	if is_hovered:
		z_index = 100
	else:
		z_index = 0


func _input(event):
	if event is InputEventMouseButton and is_hovered and is_interactable:
		is_grabbed = !is_grabbed
		if is_grabbed:
			just_grabbed.emit(parent_card)
			print("clicked")
		else:
			just_dropped.emit(parent_card)
			print("unclicked")


func applyTitle(title: String):
	cardTitle.text = title


func _on_area_2d_mouse_entered():
	if is_interactable:
		is_hovered = true


func _on_area_2d_mouse_exited():
	is_hovered = false


func _on_base_card_area_area_entered(area):
	overlapping_bodies.append(area)


func _on_base_card_area_area_exited(area):
	overlapping_bodies.erase(area)
