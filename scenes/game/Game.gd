extends Node2D

@export var cardDeck : CardDeck
@export var hand : Hand


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#cardDeck = CardDeck.new()	
	#hand = Hand.new()
	cardDeck.createDeck(20)
	
	for i in range(7):
		await get_tree().create_timer(.75).timeout
		draw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw():
	var card = cardDeck.draw()
	hand.addCard(card)
