class_name BadShorty

extends Sprite2D

enum DirectionState { left, right, up, down }
var directionState = DirectionState.left
var tileMap: TileMap
var path: Array
var pathIndex = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func setTileMap(tileMapFromParent):
	tileMap = tileMapFromParent


func setPath(pathFromParent):
	var currentTilePosition = tileMap.local_to_map(position)

	path = pathFromParent
	for i in range(len(path)):
		path[i].x += currentTilePosition.x
		path[i].y += currentTilePosition.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var currentTilePosition = tileMap.local_to_map(position)
	if currentTilePosition.x == path[pathIndex].x and currentTilePosition.y == path[pathIndex].y:
		pathIndex += 1
		if pathIndex >= len(path):
			pathIndex = 0

	if currentTilePosition.x > path[pathIndex].x:
		directionState = DirectionState.left
	elif currentTilePosition.x < path[pathIndex].x:
		directionState = DirectionState.right
	elif currentTilePosition.y > path[pathIndex].y:
		directionState = DirectionState.up
	elif currentTilePosition.y < path[pathIndex].y:
		directionState = DirectionState.down

	if directionState == DirectionState.left:
		walkLeft(delta)
	elif directionState == DirectionState.right:
		walkRight(delta)
	elif directionState == DirectionState.up:
		walkUp(delta)
	elif directionState == DirectionState.down:
		walkDown(delta)


func walkLeft(tweenTime):
	flip_h = true
	$AnimationPlayer.play("walk")
	var tween = create_tween()
	tween.tween_property(
		self, "position", Vector2(position.x - 50 * tweenTime, position.y), tweenTime
	)


func walkRight(tweenTime):
	flip_h = false
	$AnimationPlayer.play("walk")
	var tween = create_tween()
	tween.tween_property(
		self, "position", Vector2(position.x + 50 * tweenTime, position.y), tweenTime
	)


func walkDown(tweenTime):
	flip_h = true
	$AnimationPlayer.play("walk")
	var tween = create_tween()
	tween.tween_property(
		self, "position", Vector2(position.x, position.y + 50 * tweenTime), tweenTime
	)


func walkUp(tweenTime):
	flip_h = false
	$AnimationPlayer.play("walk")
	var tween = create_tween()
	tween.tween_property(
		self, "position", Vector2(position.x, position.y - 50 * tweenTime), tweenTime
	)
