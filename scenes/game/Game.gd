class_name Game

extends Node2D

@export var cardDeck: CardDeck
@export var hand: Hand
@export var map: GameLevel
@export var player: Player
@export var fadeIn: bool = false
@onready var global: GlobalClass = get_node("/root/Global")
@onready var baddie_audio_player: AudioStreamPlayer = %BaddieTurnAudioPlayer
@onready var player_audio_player: AudioStreamPlayer = %PlayerTurnAudioPlayer

var actionCount: int = 0


func updatePrevious():
	global.previousState = global.currentState


func droppedCard(card: Card):
	if global.currentState == global.States.waitingForUserCard:
		updatePrevious()

		if card.cardType == ActionCard.CardType:
			global.currentState = global.States.highlightingTiles
			map.prep_for_movement(player.global_position, card.movementAmount)
		elif card.cardType == ActionCountCard.CardType:
			addActionCount(card.actionCount)
		elif card.cardType == FlowerCard.CardType:
			playFlower(card)


func highlightFinished():
	if global.currentState == global.States.highlightingTiles:
		updatePrevious()
		global.currentState = global.States.waitingForTileClick


func aboutToMoveCharacter():
	if global.currentState == global.States.waitingForTileClick:
		updatePrevious()
		global.currentState = global.States.characterMoving
		return true

	return false


var flower1HasBeenTouched = false
var previousFlower1HasBeenTouched = false


func flower1Touched():
	flower1HasBeenTouched = true


var flower2HasBeenTouched = false
var previousFlower2HasBeenTouched = false


func flower2Touched():
	flower2HasBeenTouched = true


var flower3HasBeenTouched = false
var previousFlower3HasBeenTouched = false


func flower3Touched():
	flower3HasBeenTouched = true


func updatePreviousFlower():
	previousFlower1HasBeenTouched = flower1HasBeenTouched
	previousFlower2HasBeenTouched = flower2HasBeenTouched
	previousFlower3HasBeenTouched = flower3HasBeenTouched


func characterFinishedMoving():
	if global.currentState == global.States.characterMoving:
		updatePrevious()
		await get_tree().create_timer(.65).timeout

		var doFLowerText = false
		if flower1HasBeenTouched and not previousFlower1HasBeenTouched:
			#await showInstructionText(global.States.playingFlower, "flower collected!", true)
			#await get_tree().create_timer(1.5).timeout
			await map.collectedFlower1()
			%Flower.colorFlower1()
			doFLowerText = true
		if flower2HasBeenTouched and not previousFlower2HasBeenTouched:
			#await showInstructionText(global.States.playingFlower, "flower collected!", true)
			#await get_tree().create_timer(1.5).timeout
			await map.collectedFlower2()
			%Flower.colorFlower2()
			doFLowerText = true
		if flower3HasBeenTouched and not previousFlower3HasBeenTouched:
			#await showInstructionText(global.States.playingFlower, "flower collected!", true)
			#await get_tree().create_timer(1.5).timeout
			await map.collectedFlower3()
			%Flower.colorFlower3()
			doFLowerText = true

		if doFLowerText:
			flowerCount += 1
			if flowerCount >= 3:
				await showInstructionText(
					global.States.characterMoving, "all flowers collected!", true
				)
				await get_tree().create_timer(1.5).timeout
			else:
				await showInstructionText(
					global.States.characterMoving, str(flowerCount) + "/3 flowers collected!", true
				)
				await get_tree().create_timer(1.5).timeout

		updatePreviousFlower()

		draw()

		checkActionCount()


func discardCards():
	if (
		global.currentState == global.States.characterMoving
		or global.currentState == global.States.playingFlower
	):
		updatePrevious()
		global.currentState = global.States.discardingCards
		hand.discard_card()


func badGuysTurn():
	baddie_audio_player.play()
	await get_tree().create_timer(1).timeout
	updatePrevious()
	global.currentState = global.States.badGuysMove
	await get_tree().create_timer(1).timeout
	map.badGuysMove()


func playerLost():
	if global.currentState == global.States.badGuysMove:
		player.lose()
		print("YOU LOSE!")
		#baddie_audio_player.play()
		#await get_tree().create_timer(1).timeout
		#updatePrevious()
		#global.currentState = global.States.badGuysMove
		#await get_tree().create_timer(1).timeout
		#map.badGuysMove()


func badGuysFinished():
	updatePrevious()
	hand.show_hand()
	global.currentState = global.States.waitingForUserCard
	await get_tree().create_timer(0.65).timeout
	player_audio_player.play()


func addActionCount(count: int):
	actionCount += count
	updateActionCountLabel()
	updatePrevious()
	await get_tree().create_timer(.65).timeout
	draw()
	global.currentState = global.States.waitingForUserCard


func checkActionCount():
	if actionCount > 1:
		actionCount -= 1
		updateActionCountLabel()
		global.currentState = global.States.waitingForUserCard
	else:
		actionCount = 0
		updateActionCountLabel()
		discardCards()
		#badGuysTurn()
		#TODO Make this the enemy's turn
		#global.currentState = global.States.waitingForUserCard


func updateActionCountLabel():
	%ActionCountLabel.text = "Actions: " + str(actionCount)


var flowerCount = 0


func playFlower(card: FlowerCard):
	updatePrevious()
	global.currentState = global.States.playingFlower

	if card.flowerId == 1:
		await map.showFlower1()
		pass
	if card.flowerId == 2:
		await map.showFlower2()
		pass
	if card.flowerId == 3:
		await map.showFlower3()
		pass

	await showInstructionText(global.States.playingFlower, "flower revealed on map", true)
	await map.showDemoFlower()
	await get_tree().create_timer(2).timeout
	#
	#flowerCount += 1  
	#if flowerCount >= 3:
	#await showInstructionText(global.States.playingFlower, "all flowers revealed!", true)
	#await get_tree().create_timer(2).timeout
	#else:
	#await showInstructionText(
	#global.States.playingFlower, str(flowerCount) + "/3 flowers revealed", true
	#)
	#await get_tree().create_timer(2).timeout

	await showInstructionText(global.States.playingFlower, "gather all 3 flowers to win!", true)
	await get_tree().create_timer(2).timeout
	await showInstructionText(global.States.playingFlower, "GROW your combos for victory!", true)
	await get_tree().create_timer(2).timeout

	await map.hideDemoFlower()

	draw()
	checkActionCount()


# Called when the node enters the scene tree for the first time.
func _ready():
	if fadeIn:
		var z = global.currentState
		fade_in()
		draw_first_hand()
	map.setPlayer(player)
	hand.game = self
	map.game = self
	%Flower.hideFlower()


func fade_in():
	%FadeInRect.modulate.a = 255
	var tween = create_tween()
	tween.tween_property(%FadeInRect, "modulate:a", 0, 0.25).set_ease(Tween.EASE_OUT)


func hideInstructionText(state):
	if lastProcessState != state:
		lastProcessState = state
		var tween = create_tween()
		tween.tween_property(%InstructionLabel, "modulate:a", 0, .25)
		await tween.finished


func showInstructionText(state, text, force = false):
	if lastProcessState != state or force:
		lastProcessState = state

		if %InstructionLabel.modulate.a == 1:
			var tween = create_tween()
			tween.tween_property(%InstructionLabel, "modulate:a", 0, .25)
			await tween.finished

		%InstructionLabel.text = text

		var tween2 = create_tween()
		tween2.tween_property(%InstructionLabel, "modulate:a", 1, .25)
		await tween2.finished


var lastProcessState = global.States.waitingForstart
var lastProcessActionCount = 0
var showingInfo = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var z = global.currentState
	if global.currentState == global.States.waitingForUserCard:
		#if lastProcessState != global.States.waitingForUserCard:
		#lastProcessState = global.currentState
		#%InstructionLabel.text = 'play NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO card'
		#var tween = create_tween()
		#tween.tween_property(%InstructionLabel, 'modulate:a', 0, 2)
		#await tween.finished
		#
		#%InstructionLabel.text = 'play a card'
		#var tween2 = create_tween()
		#tween2.tween_property(%InstructionLabel, 'modulate:a', 1, 2)
		#await tween.finished
		#

		if showingInfo:
			pass
		elif lastProcessState == global.States.waitingForstart:
			showingInfo = true
			await showInstructionText(global.States.playingFlower, "play cards to", true)
			await get_tree().create_timer(2).timeout
			await showInstructionText(global.States.playingFlower, "move", true)
			await get_tree().create_timer(2).timeout
			await showInstructionText(global.States.playingFlower, "GROW combos", true)
			await get_tree().create_timer(2).timeout
			await showInstructionText(global.States.playingFlower, "and collect flowers", true)
			await get_tree().create_timer(3).timeout
			await showInstructionText(
				global.States.playingFlower, "play flower cards to reveal flowers", true
			)
			await get_tree().create_timer(2).timeout
			await showInstructionText(
				global.States.playingFlower, "collect flowers by moving to them", true
			)
			await get_tree().create_timer(2).timeout
			await get_tree().create_timer(2).timeout
			await showInstructionText(global.States.playingFlower, "play a card", true)
			showingInfo = false

		elif lastProcessActionCount != actionCount and actionCount > 0:
			lastProcessActionCount = actionCount
			if actionCount == 1:
				await showInstructionText(
					global.States.waitingForUserCard,
					"COMBO! play " + str(actionCount) + " card!",
					true
				)
			else:
				await showInstructionText(
					global.States.waitingForUserCard,
					"COMBO! play " + str(actionCount) + " cards!",
					true
				)

		elif actionCount == 0:
			lastProcessActionCount = 0
			await showInstructionText(global.States.waitingForUserCard, "play a card")

	elif global.currentState == global.States.highlightingTiles:
		await hideInstructionText(global.States.highlightingTiles)

	elif global.currentState == global.States.waitingForTileClick:
		await showInstructionText(global.States.waitingForTileClick, "click flashing tile to move")

	elif global.currentState == global.States.characterMoving:
		await hideInstructionText(global.States.characterMoving)

	elif global.currentState == global.States.showPossibleSpaces:
		await hideInstructionText(global.States.showPossibleSpaces)

	elif global.currentState == global.States.discardingCards:
		await hideInstructionText(global.States.discardingCards)

	elif global.currentState == global.States.badGuysMove:
		await showInstructionText(global.States.badGuysMove, "baddies moving")

	elif global.currentState == global.States.multipleActionState:
		#await showInstructionText(global.States.multipleActionState, 'XXXXXXXXXX')
		pass

	lastProcessState = global.currentState


func draw_first_hand():
	for i in range(7):
		global.currentState = global.States.waitingForUserCard
		await get_tree().create_timer(.25).timeout
		draw()


func draw():
	var card = cardDeck.draw()
	hand.addCard(card)


func _input(event):
	if event.is_action_pressed("start_sim"):
		draw_first_hand()

#func delay(time):
#await get_tree().create_timer(time).timeout
