class_name ActionCountCard

extends Card

@export var baseCardVisual: BaseCardVisual
const CardType = "ActionCountCard"

var actionCount:int = -1

func _ready():
	cardType = CardType


func _process(delta):
	pass


func createCard(count: int):
	actionCount = count
	var title = "Action: {}".format([count], "{}")
	baseCardVisual.applyTitle(title)
