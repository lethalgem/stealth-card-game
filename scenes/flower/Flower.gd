class_name Flower

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hideFlower():
	%FlowerJoinedPart1.modulate = Color("#00000000")
	%FlowerJoinedPart2.modulate = Color("#00000000")
	%FlowerJoinedPart3.modulate = Color("#00000000")


#func colorFlower():
#await colorFlower1()
#await colorFlower2()
#await colorFlower3()


func colorFlower1():
	await %FlowerJoinedPart1.showColor()
	#$AnimationPlayer1.play('Show')
	#%FlowerJoinedPart1.modulate = Color("#ffffffff")


func colorFlower2():
	#%FlowerJoinedPart2.modulate = Color("#ffffffff")
	await %FlowerJoinedPart2.showColor()


func colorFlower3():
	#%FlowerJoinedPart3.modulate = Color("#ffffffff")
	await %FlowerJoinedPart3.showColor()
