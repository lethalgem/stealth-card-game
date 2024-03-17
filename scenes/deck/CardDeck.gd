class_name CardDeck

extends Node2D

var cardCount = 0
# 1 = action (movement for now)
# 2 = action count
# use by listing vector2s of (card_type, actioncount/movementspeed)
var deck_gen: PackedVector2Array = [
	Vector2(1, 3),
	Vector2(1, 4),
	Vector2(1, 5),
	Vector2(1, 6),
	Vector2(1, 7),
	Vector2(1, 8),
	Vector2(1, 9),
	Vector2(1, 10),
	Vector2(1, 11),
	Vector2(1, 12),
	Vector2(1, 13),
	Vector2(1, 14),
	Vector2(2, 2),
	Vector2(2, 3),
	Vector2(2, 3),
	Vector2(2, 2),
	Vector2(2, 2),
]

@onready var deck_shuffling_audio_player: AudioStreamPlayer2D = %DeckShufflingAudioPlayer

var cards: Array = []
var actionCardScene = preload("res://scenes/cards/ActionCard.tscn")
var actionCountCardScene = preload("res://scenes/cards/ActionCountCard.tscn")
var flowerCardScene = preload("res://scenes/cards/FlowerCard.tscn")

signal deckLocation(Vector2)


# Called when the node enters the scene tree for the first time.
func _ready():
	createDeck()
	addFlowerCards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func createDeck():
	for card_to_gen in deck_gen:
		createCard(card_to_gen)
	deckLocation.emit(global_position)
	deck_shuffling_audio_player.play()


func addFlowerCards():
	for i in range(1, 4):
		cards.append(createFlowerCard(i))


func checkTop7CardsForFlower():
	for i in range(7):
		if cards[i].CardType == FlowerCard.CardType:
			return true

	return false


func pop3ToBack():
	cards.push_back(cards.pop_front())
	cards.push_back(cards.pop_front())
	cards.push_back(cards.pop_front())


var firstPlay = true


func draw():
	if len(cards) == 1:
		createDeck()
	cards.shuffle()

	if firstPlay:
		while not checkTop7CardsForFlower():
			pop3ToBack()
		firstPlay = false

	var card = cards.pop_front()
	return card


func createCard(card_to_gen: Vector2):
	match card_to_gen.x:
		float(1):
			cards.append(createActionCard(card_to_gen.y))
		float(2):
			cards.append(createActionCountCard(card_to_gen.y))
		_:
			print("unrecognized card to generate")


func createActionCard(actions: int) -> Card:
	var actionCard = actionCardScene.instantiate()
	actionCard.createCard(actions)
	return actionCard


func createActionCountCard(actions: int) -> Card:
	var actionCountCard = actionCountCardScene.instantiate()
	actionCountCard.createCard(actions)
	return actionCountCard


func createFlowerCard(actions: int) -> Card:
	var flowerCard = flowerCardScene.instantiate()
	flowerCard.createCard(actions)
	return flowerCard
