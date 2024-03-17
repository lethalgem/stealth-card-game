class_name GlobalClass

extends Node2D

enum States {
	waitingForUserCard,
	highlightingTiles,
	waitingForTileClick,
	characterMoving,
	showPossibleSpaces,
	discardingCards,
	badGuysMove,
	multipleActionState,
}

var previousState: States = States.waitingForUserCard
var currentState: States = States.waitingForUserCard


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
