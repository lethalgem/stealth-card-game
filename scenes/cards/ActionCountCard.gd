class_name ActionCountCard

extends Card

@export var baseCardVisual: BaseCardVisual
const CardType = 'ActionCountCard'

func _ready():
	cardType = CardType


	#createCard(3)
	
func _process(delta):
	pass


func createCard(count: int):
	var title = "Action: {}".format([count], "{}")
	baseCardVisual.applyTitle(title)
