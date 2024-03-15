class_name Hand

extends Node2D

var cardCount = 0
var cards = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addCard(card:Card):
	cardCount += 1
	cards.append(card)
	
	var x = 4

func play():
	cardCount -= 1




	
