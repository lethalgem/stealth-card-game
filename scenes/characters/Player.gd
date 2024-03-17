class_name Player

extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idleDown")

var lost = false
func lose():
	if not lost: 
		$AnimationPlayer.play("lose")
	lost = true

func moveTo(incomingPosition):
	if lost:
		return
		
	var originalPosition = position

	$AnimationPlayer.play("teleport")

	await get_tree().create_timer(.25).timeout
	position = incomingPosition

	%PlayerTeleportAudioPlayer.play()

	$AnimationPlayer.play("teleport_end")
	await get_tree().create_timer(.5).timeout

	if abs(originalPosition.x - incomingPosition.x) >= abs(originalPosition.y - incomingPosition.y):
		if incomingPosition.x >= originalPosition.x:
			$AnimationPlayer.play("idleRight")
		else:
			$AnimationPlayer.play("idleLeft")
	else:
		if incomingPosition.y >= originalPosition.y:
			$AnimationPlayer.play("idleDown")
		else:
			$AnimationPlayer.play("idleUp")
