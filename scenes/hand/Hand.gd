class_name Hand

extends Node2D

var cardCount = 0
var cards = []
var deckLocation

@export var leftMarker:Marker2D
@export var rightMarker:Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_deck_deck_location(location):
	deckLocation = location

func addCard(card:Card):

	card.scale.x = .5
	card.scale.y = .5

	add_child(card)

	card.position.x =  deckLocation.x - card.global_position.x
	card.position.y = deckLocation.y - card.global_position.y
	card.rotation = 0 #deg_to_rad(0)

	cards.append(card)

	var cardWidth = 275	/ 2
	#for child in card.get_children():
		#if child is ColorRect:
			#cardWidth = child.size.x
			#break

	var maxDistanceBetweenCards = cardWidth * 1.1

	var distanceBetweenCards = maxDistanceBetweenCards
	if len(cards) > 1:
		distanceBetweenCards = (rightMarker.position.x - leftMarker.position.x) / (len(cards) - 1)
		distanceBetweenCards = min(distanceBetweenCards, maxDistanceBetweenCards)

	var rightMost = ((len(cards) - 1) / 2) * distanceBetweenCards
	var leftMost = - ((len(cards) - 1) / 2) * distanceBetweenCards

	var rightMostRotation = 15
	var leftMostRotation = -15
	var rotationBetweenCards = 0
	if len(cards) > 1:
		rotationBetweenCards = (rightMostRotation - leftMostRotation) / (len(cards) - 1)

	var mod = len(cards) % 2
	#if len(cards) % 2 == 0:
	if mod == 0:
		rightMost -= cardWidth / 2
		leftMost -= cardWidth / 2

	var positions:Array = []
	var rotations:Array = []
	if len(cards) <= 1:
		positions.append(0)
		rotations.append(0)
	else:
		#var distanceBetweenCards = (rightMarker.position.x - leftMarker.position.x) / (len(cards) - 1)
		for i in range(len(cards)):
			#positions.append(leftMarker.position.x + i*distanceBetweenCards)
			positions.append(leftMost + i*distanceBetweenCards)
			rotations.append(leftMostRotation + i*rotationBetweenCards)
	
	var yPositions:Array = []
	var yAdjust = 10;
	var yOffset = -20;
	if len(cards) <= 2:
		for i in range(len(cards)):
			yPositions.append(0)
	elif len(cards) % 2 == 0:
		for i in range(len(cards) / 2):
			yPositions.append( (((len(cards) / 2) - 1) - i) * yAdjust)
		for i in range(len(cards) / 2):
			yPositions.append(yPositions[((len(cards) / 2) - 1) - i])
	else:
		for i in range(int(len(cards) / 2)):
			yPositions.append( ( int(len(cards) / 2) - i) * yAdjust)
		yPositions.append(0)
		for i in range(int(len(cards) / 2)):
			yPositions.append(yPositions[ int(len(cards) / 2)  - i - 1])
		

	var tweenTime = .5

	for i in range(len(cards)):
		var tween = create_tween()
		tween.tween_property(cards[i], 'rotation', deg_to_rad(rotations[i]), tweenTime)
		tween.parallel().tween_property(cards[i], 'position', Vector2(positions[i], yPositions[i] + yOffset), tweenTime)
		

	#tween.tween_property(card, 'rotation', deg_to_rad(-15), tweenTime)
	#tween.parallel().tween_property(card, 'position', Vector2(0, 0), tweenTime)

	if card.cardType == ActionCountCard.CardType:
		pass
	elif card.cardType == ActionCard.CardType:
		pass
	elif card.cardType == FlowerCard.CardType:
		pass

	cardCount += 1

	var x = 4

func play():
	cardCount -= 1

