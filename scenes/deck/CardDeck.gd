class_name CardDeck

extends Node2D

var cardCount = 0
# 1 = action (movement for now)
# 2 = action count
# use by listing vector2s of (card_type, actioncount/movementspeed)
var deck_gen: PackedVector2Array = [
	Vector2(1, 1),
	Vector2(1, 2),
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
var cards: Array = []
var actionCountCardScene = preload("res://scenes/cards/ActionCountCard.tscn")
var actionCardScene = preload("res://scenes/cards/ActionCard.tscn")

signal deckLocation(Vector2)


# Called when the node enters the scene tree for the first time.
func _ready():
	createDeck()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func createDeck():
	for card_to_gen in deck_gen:
		print(card_to_gen)
		createCard(card_to_gen)
	deckLocation.emit(global_position)


func draw():
	if len(cards) == 1:
		createDeck()
	cards.shuffle()
	var card = cards.pop_front()
	return card


func createCard(card_to_gen: Vector2):
	print(card_to_gen.x)
	match card_to_gen.x:
		float(1):
			print("action card")
			cards.append(createActionCard(card_to_gen.y))
		float(2):
			print("action count card")
			cards.append(createActionCountCard(card_to_gen.y))
		_:
			print("unrecognized card to generate")


func createActionCountCard(actions: int) -> Card:
	var actionCountCard = actionCountCardScene.instantiate()
	actionCountCard.createCard(actions)
	return actionCountCard


func createActionCard(actions: int) -> Card:
	var actionCard = actionCardScene.instantiate()
	actionCard.createCard(actions)
	return actionCard
