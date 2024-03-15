class_name CardDeck

extends Node2D

var random = RandomNumberGenerator.new()

var cards:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var cardCount = 20
	for i in range(cardCount):
		createCard()
		
	var x = 3
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func createDeck(cardCount:int):
	self.cardCount = cardCount

func draw():
	var card = cards.pop_front()
	return card

func createCard():
	var actionCountCard = createActionCountCard()

	cards.append(actionCountCard)

func createActionCountCard():
	var number = random.randi_range(1,5)
	
	var actionCountCardScene = preload("res://scenes/cards/ActionCountCard.tscn")
	var actionCountCard = actionCountCardScene.instantiate()
	actionCountCard.createCard(number)
	
	add_child(actionCountCard)
	
	return actionCountCard
	
	
