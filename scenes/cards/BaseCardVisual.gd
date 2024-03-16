class_name BaseCardVisual

extends Node2D

@export var cardTitle: Label
@export var parent_card: Card

@onready var global: GlobalClass = get_node("/root/Global")

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
	if (
		event.is_action_pressed("user_click")
		and is_hovered
		and is_interactable
		and (global.currentState == global.States.waitingForUserCard)
	):
		is_grabbed = true
		just_grabbed.emit(parent_card)
		print("grabbed")

	elif event.is_action_released("user_click"):
		print("released")
		if is_grabbed:
			is_grabbed = false
			just_dropped.emit(parent_card)
			print("dropped")


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
