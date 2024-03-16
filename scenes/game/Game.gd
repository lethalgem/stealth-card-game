class_name Game 

extends Node2D

@export var cardDeck: CardDeck
@export var hand: Hand
@export var map: GameLevel
@export var player: Player
@onready var global : GlobalClass = get_node("/root/Global")
var action_count: int = 0



#func tryTransition():
	#match currentState:
		#States.waitingForUserCard:
			#
			#
	#
	#
	#
	#
	#return false
	

func updatePrevious():
		global.previousState = global.currentState

func droppedCard():
	if global.currentState == global.States.waitingForUserCard:
		updatePrevious()
		global.currentState = global.States.highlightingTiles
		
		map.prep_for_movement(player.global_position)

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
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	cardDeck.createDeck(20)
	map.setPlayer(player)
	hand.game = self
	map.game = self
	

	for i in range(7):
		await get_tree().create_timer(.4).timeout
		draw()


#func _input(event):
	#if event.is_action_pressed("start_sim"):
		#action_count = 1
		#prep_for_movement()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func draw():
	var card = cardDeck.draw()
	hand.addCard(card)


#func prep_for_movement():
	#map.prep_for_movement(player.global_position)
