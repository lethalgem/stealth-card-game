class_name FlowerCard

extends Card

@export var baseCardVisual: BaseCardVisual
const CardType = 'FlowerCard'

var flowerId = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	cardType = CardType
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func createCard(count: int):
	#actionCount = count
	#var title = "Action: {}".format([count], "{}")
	flowerId = count
	baseCardVisual.applyTitle('flower')
