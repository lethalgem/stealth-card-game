class_name BasShorty

extends Sprite2D

enum DirectionState { left, right, up, down }
var directionState = DirectionState.left

# Called when the node enters the scene tree for the first time.
func _ready():
	#walkLeft()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if directionState == DirectionState.left:
		walkLeft(delta)
	elif directionState == DirectionState.right:
		walkRight(delta)
	
	#pass

func walkLeft(tweenTime):
	flip_h = true
	$AnimationPlayer.play('walk')
	#var tweenTime = 2
	var tween = create_tween()
	tween.tween_property(self, 'position', Vector2(position.x - 50 * tweenTime , position.y), tweenTime)
	
	if position.x < -200:
		directionState = DirectionState.right
	
	
func walkRight(tweenTime):
	flip_h = false
	$AnimationPlayer.play('walk')
	#var tweenTime = 2
	var tween = create_tween()
	tween.tween_property(self, 'position', Vector2(position.x + 50 * tweenTime , position.y), tweenTime)

	if position.x > 200:
		directionState = DirectionState.left
