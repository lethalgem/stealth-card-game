class_name Player

extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('idleDown')
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func walkLeft(tweenTime):
func moveTo(incomingPosition):
	var originalPosition = position

	#flip_h = true
	$AnimationPlayer.play('teleport')

	await get_tree().create_timer(.25).timeout
	position = incomingPosition

	$AnimationPlayer.play('teleport_end')
	await get_tree().create_timer(.5).timeout

	if abs(originalPosition.x - incomingPosition.x) >= abs(originalPosition.y - incomingPosition.y):
		if incomingPosition.x >= originalPosition.x:
			$AnimationPlayer.play('idleRight')
		else:
			$AnimationPlayer.play('idleLeft')
	else:
		if incomingPosition.y >= originalPosition.y:
			$AnimationPlayer.play('idleDown')
		else:
			$AnimationPlayer.play('idleUp')




	#await get_tree().create_timer(.5).timeout
	#
	#var tween = create_tween()
	#tween.tween_property(self, 'position', Vector2(position.x + 500 , position.y), 2)
	#pass

