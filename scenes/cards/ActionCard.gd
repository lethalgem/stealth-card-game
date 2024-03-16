class_name ActionCard

extends Card

@export var baseCardVisual: BaseCardVisual
const CardType = "ActionCard"

var movementAmount:int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	cardType = CardType


func createCard(count: int):
	movementAmount = count
	var title = "Move {}".format([count], "{}")
	baseCardVisual.applyTitle(title)
