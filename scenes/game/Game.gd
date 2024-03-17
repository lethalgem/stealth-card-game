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


func droppedCard(card:Card):
	if global.currentState == global.States.waitingForUserCard:
		updatePrevious()
		global.currentState = global.States.highlightingTiles

		if card.cardType == ActionCard.CardType:
			map.prep_for_movement(player.global_position, card.movementAmount)
		elif card.cardType == ActionCountCard.CardType:
			addActionCount(card.actionCount)

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
		global.currentState = global.States.waitingForUserCard



func addActionCount(count:int):
	actionCount += count
	updateActionCountLabel()
	updatePrevious()
	await get_tree().create_timer(.65).timeout
	draw()
	global.currentState = global.States.waitingForUserCard

func checkActionCount():
	if actionCount > 0:
		actionCount -= 1
		updateActionCountLabel()
		global.currentState = global.States.waitingForUserCard
	else:
		#TODO Make this the enemy's turn
		global.currentState = global.States.waitingForUserCard

func updateActionCountLabel():
		%ActionCountLabel.text = 'Actions: ' + str(actionCount)


# Called when the node enters the scene tree for the first time.
func _ready():
	map.setPlayer(player)
	hand.game = self
	map.game = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func draw():
	var card = cardDeck.draw()
	hand.addCard(card)


func _input(event):
	if event.is_action_pressed("start_sim"):
		for i in range(7):
			await get_tree().create_timer(.25).timeout
			draw()

#func delay(time):
	#await get_tree().create_timer(time).timeout
