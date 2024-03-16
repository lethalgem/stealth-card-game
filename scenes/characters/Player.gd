class_name Player

extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#func walkLeft(tweenTime):
func moveTo(tilePosition):
	#flip_h = true
	$AnimationPlayer.play('walk_right')
	var tween = create_tween()
	tween.tween_property(self, 'position', Vector2(position.x + 500 , position.y), 2)
	#pass
