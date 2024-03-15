extends Node2D

@export var baseCard: BaseCard


func _ready():
	createCard(3)


func createCard(count: int):
	var title = "Action: {}".format([count], "{}")
	baseCard.applyTitle(title)
