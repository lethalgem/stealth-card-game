class_name Hand

extends Node2D

var cardCount = 0
var cards = []
var grabbed_card: Card
var deckLocation
var played_cards = []
var game: Game:
	set(value):
		game = value

@export var leftMarker: Marker2D
@export var rightMarker: Marker2D
@export var playPile: Area2D
@export var debugMode: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if debugMode:
		var viewport = get_viewport_rect().size
		global_position = Vector2(viewport.x / 2, viewport.y / 1.2)
		var testCard = preload("res://scenes/cards/ActionCountCard.tscn")
		for i in 3:
			var newCard = testCard.instantiate()
			deckLocation = Vector2(global_position.x + 500, global_position.y)
			addCard(newCard)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_deck_deck_location(location):
	deckLocation = location


func addCard(card: Card):
	card.scale.x = .5
	card.scale.y = .5

	add_child(card)

	card.position.x = deckLocation.x - card.global_position.x
	card.position.y = deckLocation.y - card.global_position.y
	card.rotation = 0

	card.get_node("BaseCardVisual").just_grabbed.connect(card_grabbed.bind())
	card.get_node("BaseCardVisual").just_dropped.connect(card_dropped.bind())

	cards.append(card)

	position_cards()


func position_cards():
	var cardWidth = 275 / 2

	var maxDistanceBetweenCards = cardWidth * 1.1

	var distanceBetweenCards = maxDistanceBetweenCards
	if len(cards) > 1:
		distanceBetweenCards = (rightMarker.position.x - leftMarker.position.x) / (len(cards) - 1)
		distanceBetweenCards = min(distanceBetweenCards, maxDistanceBetweenCards)

	var rightMost = ((len(cards) - 1) / 2) * distanceBetweenCards
	var leftMost = -((len(cards) - 1) / 2) * distanceBetweenCards

	var rightMostRotation = 15
	var leftMostRotation = -15
	var rotationBetweenCards = 0
	if len(cards) > 1:
		rotationBetweenCards = (rightMostRotation - leftMostRotation) / (len(cards) - 1)

	var mod = len(cards) % 2
	if mod == 0:
		rightMost -= cardWidth / 2
		leftMost -= cardWidth / 2

	var positions: Array = []
	var rotations: Array = []
	if len(cards) <= 1:
		positions.append(0)
		rotations.append(0)
	else:
		for i in range(len(cards)):
			positions.append(leftMost + i * distanceBetweenCards)
			rotations.append(leftMostRotation + i * rotationBetweenCards)

	var yPositions: Array = []
	var yAdjust = 10
	var yOffset = -20
	if len(cards) <= 2:
		for i in range(len(cards)):
			yPositions.append(0)
	elif len(cards) % 2 == 0:
		for i in range(len(cards) / 2):
			yPositions.append((((len(cards) / 2) - 1) - i) * yAdjust)
		for i in range(len(cards) / 2):
			yPositions.append(yPositions[((len(cards) / 2) - 1) - i])
	else:
		for i in range(int(len(cards) / 2)):
			yPositions.append((int(len(cards) / 2) - i) * yAdjust)
		yPositions.append(0)
		for i in range(int(len(cards) / 2)):
			yPositions.append(yPositions[int(len(cards) / 2) - i - 1])

	var tweenTime = .25

	for i in range(len(cards)):
		var tween = create_tween()
		tween.tween_property(cards[i], "rotation", deg_to_rad(rotations[i]), tweenTime)
		tween.parallel().tween_property(
			cards[i], "position", Vector2(positions[i], yPositions[i] + yOffset), tweenTime
		)

	cardCount += 1


func card_grabbed(card: Card):
	print("got it ")
	grabbed_card = card
	cards.erase(card)
	for cards_in_hands in cards:
		cards_in_hands.get_node("BaseCardVisual").is_interactable = false
	position_cards()


func card_dropped(card: Card):
	var overlapping_bodies = grabbed_card.get_node("BaseCardVisual").overlapping_bodies
	if overlapping_bodies.has(playPile):
		grabbed_card.get_node("BaseCardVisual").is_interactable = false
		played_cards.append(grabbed_card)
		distribute_play_pile()
		game.droppedCard(card)

	else:
		cards.append(grabbed_card)
		position_cards()
	grabbed_card = null
	for cards_in_hand in cards:
		cards_in_hand.get_node("BaseCardVisual").is_interactable = true


func distribute_play_pile():
	var cardIndex = 0
	for card in played_cards:
		card.z_index = cardIndex
		cardIndex += 1


func play():
	cardCount -= 1
