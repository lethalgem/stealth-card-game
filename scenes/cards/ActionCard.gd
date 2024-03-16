class_name ActionCard

extends Card

@export var baseCardVisual: BaseCardVisual
const CardType = "ActionCard"


# Called when the node enters the scene tree for the first time.
func _ready():
	cardType = CardType


func createCard(count: int):
	var title = "Move {}".format([count], "{}")
	baseCardVisual.applyTitle(title)
