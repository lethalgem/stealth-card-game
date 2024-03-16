class_name CardDeck

extends Node2D

var random = RandomNumberGenerator.new()

var cardCount = 0
var cards:Array = []

signal deckLocation(Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func createDeck(count:int):
	cardCount = count
	for i in range(cardCount):
		createCard()
	deckLocation.emit(global_position)

func draw():
	var card = cards.pop_front()
	return card

func createCard():
	var actionCountCard = createActionCountCard()

	cards.append(actionCountCard)

var cardsCreated = 0
func createActionCountCard():

	var number = random.randi_range(1,5)
	cardsCreated += 1
	number = cardsCreated

	var actionCountCardScene = preload("res://scenes/cards/ActionCountCard.tscn")
	var actionCountCard = actionCountCardScene.instantiate()
	actionCountCard.createCard(number)

	return actionCountCard


