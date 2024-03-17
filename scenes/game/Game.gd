class_name Game

extends Node2D

@export var cardDeck: CardDeck
@export var hand: Hand
@export var map: GameLevel
@export var player: Player
@onready var global: GlobalClass = get_node("/root/Global")
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


func characterFinishedMoving():
	if global.currentState == global.States.characterMoving:
		updatePrevious()
		#delay(.4)
		await get_tree().create_timer(.65).timeout
		draw()

		checkActionCount()
		#global.currentState = global.States.waitingForUserCard


func discardCards():
	if global.currentState == global.States.characterMoving:
		updatePrevious()
		global.currentState = global.States.discardingCards
		hand.discard_card()


func badGuysTurn():
	updatePrevious()
	global.currentState = global.States.badGuysMove
	map.badGuysMove()


func badGuysFinished():
	updatePrevious()
	hand.show_hand()
	global.currentState = global.States.waitingForUserCard


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


func playFlower(card: FlowerCard):
	if card.flowerId == 1:
		%Flower.colorFlower1()
		pass
	if card.flowerId == 2:
		%Flower.colorFlower2()
		pass
	if card.flowerId == 3:
		%Flower.colorFlower3()
		pass
	draw()
	global.currentState = global.States.waitingForUserCard


# Called when the node enters the scene tree for the first time.
func _ready():
	map.setPlayer(player)
	hand.game = self
	map.game = self
	%Flower.hideFlower()

func hideInstructionText(state):
	if lastProcessState != state:
		lastProcessState = state
		var tween = create_tween()
		tween.tween_property(%InstructionLabel, 'modulate:a', 0, .25)
		await tween.finished

func showInstructionText(state, text, force = false):
	if lastProcessState != state or force:
		lastProcessState = state

		if %InstructionLabel.modulate.a == 1:
			var tween = create_tween()
			tween.tween_property(%InstructionLabel, 'modulate:a', 0, .25)
			await tween.finished

		%InstructionLabel.text = text

		var tween2 = create_tween()
		tween2.tween_property(%InstructionLabel, 'modulate:a', 1, .25)
		await tween2.finished

var lastProcessState = global.States.badGuysMove
var lastProcessActionCount = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

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
		if lastProcessActionCount != actionCount and actionCount > 0:
			lastProcessActionCount = actionCount
			if actionCount == 1:
				await showInstructionText(global.States.waitingForUserCard, 'COMBO! play ' + str(actionCount) + ' card!', true)
			else:
				await showInstructionText(global.States.waitingForUserCard, 'COMBO! play ' + str(actionCount) + ' cards!', true)

		elif actionCount == 0:
			lastProcessActionCount = 0
			await showInstructionText(global.States.waitingForUserCard, 'play a card')

	elif global.currentState == global.States.highlightingTiles:
		await hideInstructionText(global.States.highlightingTiles)

	elif global.currentState == global.States.waitingForTileClick:
		await showInstructionText(global.States.waitingForTileClick, 'click flashing tile to move')

	elif global.currentState == global.States.characterMoving:
		await hideInstructionText(global.States.characterMoving)

	elif global.currentState == global.States.showPossibleSpaces:
		await hideInstructionText(global.States.showPossibleSpaces)

	elif global.currentState == global.States.discardingCards:
		await hideInstructionText(global.States.discardingCards)

	elif global.currentState == global.States.badGuysMove:
		await showInstructionText(global.States.badGuysMove, 'baddies moving')

	elif global.currentState == global.States.multipleActionState:
		#await showInstructionText(global.States.multipleActionState, 'XXXXXXXXXX')
		pass

	lastProcessState = global.currentState



func draw():
	var card = cardDeck.draw()
	hand.addCard(card)
	#%Flower.colorFlower()


func _input(event):
	if event.is_action_pressed("start_sim"):
		for i in range(7):
			global.currentState = global.States.waitingForUserCard
			await get_tree().create_timer(.25).timeout
			draw()

#func delay(time):
#await get_tree().create_timer(time).timeout
