class_name Hand

extends Node2D

var cardCount = 0
var cards = []
var grabbed_card: Card
var deckLocation
var played_cards = []
var discarded_cards = []
var card_being_discarded: Card
var game: Game:
	set(value):
		game = value

@onready var smoke_animation: AnimatedSprite2D = %SmokeAnimatedSprite
@onready var smoke_animation_2: AnimatedSprite2D = %SmokeAnimatedSprite2
@onready var smoke_sound_player: AudioStreamPlayer2D = %SmokeSoundPlayer
@onready var discard_pile: Marker2D = %DiscardPile

@onready var card_draw_audio_player: AudioStreamPlayer2D = %CardDrawAudioPlayer
@onready var card_draw_sounds = [
	preload("res://assets/sound/card_dealt_1.mp3"),
	preload("res://assets/sound/card_dealt_2.mp3"),
	preload("res://assets/sound/card_dealt_3.mp3")
]
@onready var card_play_audio_player: AudioStreamPlayer2D = %CardPlayAudioPlayer
@onready var card_sliding_audio_player: AudioStreamPlayer2D = %CardSlidingAudioPlayer

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


func _on_card_deck_deck_location(location):
	deckLocation = location


func addCard(card: Card):
	card.scale.x = .4
	card.scale.y = .4

	add_child(card)

	card.position.x = deckLocation.x - card.global_position.x
	card.position.y = deckLocation.y - card.global_position.y
	card.rotation = 0

	card.get_node("BaseCardVisual").just_grabbed.connect(card_grabbed.bind())
	card.get_node("BaseCardVisual").just_dropped.connect(card_dropped.bind())

	cards.append(card)

	position_cards()

	playCardDrawSound()


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

	var tweenTime = .2

	for i in range(len(cards)):
		var tween = create_tween()
		tween.tween_property(cards[i], "rotation", deg_to_rad(rotations[i]), tweenTime)
		tween.parallel().tween_property(
			cards[i], "position", Vector2(positions[i], yPositions[i] + yOffset), tweenTime
		)

	cardCount += 1
	playCardSlidingSound()


func card_grabbed(card: Card):
	grabbed_card = card
	cards.erase(card)
	for cards_in_hands in cards:
		cards_in_hands.get_node("BaseCardVisual").is_interactable = false
	position_cards()


func card_dropped(card: Card):
	var overlapping_bodies = grabbed_card.get_node("BaseCardVisual").overlapping_bodies
	if overlapping_bodies.has(playPile):
		grabbed_card.get_node("BaseCardVisual").is_interactable = false
		grabbed_card.get_node("BaseCardVisual").is_played = true
		played_cards.append(grabbed_card)
		distribute_play_pile()
		playCardPlaySound()
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


func playCardDrawSound():
	var sound = card_draw_sounds.pick_random()
	card_draw_audio_player.stream = sound
	card_draw_audio_player.play()


func playCardPlaySound():
	card_play_audio_player.play()


func playCardSlidingSound():
	card_sliding_audio_player.play()


func discard_card():
	if len(played_cards) > 0:
		card_being_discarded = played_cards[0]
		playCardDestroySmoke(card_being_discarded)
		discarded_cards.append(card_being_discarded)
		played_cards.erase(card_being_discarded)


func playCardDestroySmoke(card: Card):
	smoke_animation.global_position = card.global_position
	smoke_animation.visible = true
	smoke_animation.play()
	smoke_sound_player.play()
	card_being_discarded.visible = false


func playCardAppearedSmoke(card: Card):
	smoke_animation_2.global_position = card.global_position
	smoke_animation_2.visible = true
	smoke_animation_2.play()
	smoke_sound_player.play()


func play():
	cardCount -= 1


func _on_smoke_animated_sprite_animation_finished():
	smoke_animation.visible = false
	card_being_discarded.global_position = discard_pile.global_position
	playCardAppearedSmoke(card_being_discarded)
	card_being_discarded.get_node("BaseCardVisual").is_played = false
	card_being_discarded.z_index = len(discarded_cards)
	card_being_discarded.visible = true


func _on_smoke_animated_sprite_2_animation_finished():
	smoke_animation_2.visible = false
	card_being_discarded = null
	if len(played_cards) > 0:
		discard_card()
	else:
		hide_hand()
		game.badGuysTurn()


func hide_hand():
	await get_tree().create_timer(.65).timeout
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", global_position.y + 100, 0.35).set_ease(
		Tween.EASE_IN_OUT
	)
	card_sliding_audio_player.play()


func show_hand():
	await get_tree().create_timer(.65).timeout
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", global_position.y - 100, 0.35).set_ease(
		Tween.EASE_IN_OUT
	)
	card_sliding_audio_player.play()
