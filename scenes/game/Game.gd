extends Node2D

@export var cardDeck: CardDeck
@export var hand: Hand
@export var map: GameLevel
@export var player: TestPlayer
var action_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	cardDeck.createDeck(20)

	for i in range(7):
		await get_tree().create_timer(.75).timeout
		draw()


func _input(event):
	if event.is_action_pressed("start_sim"):
		action_count = 1
		prep_for_movement()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func draw():
	var card = cardDeck.draw()
	hand.addCard(card)


func prep_for_movement():
	map.prep_for_movement(player.global_position)
