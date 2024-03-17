class_name BadShorty

extends Sprite2D

@export var visible_range: int = 6
@export var visible_width: int = 2  # *2

enum DirectionState { left, right, up, down }
@export var directionState = DirectionState.left
var tileMap: TileMap
var gameLevel: GameLevel
var path: Array
var pathIndex = 0
var current_tile_position: Vector2i
var tiles_in_visible_range: Dictionary = {}
var confirmed_visible_tiles: Array = []

static var random = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(random.randf_range(.1, .8)).timeout
	$AnimationPlayer.play("idle")
	pass


func setTileMap(tileMapFromParent):
	tileMap = tileMapFromParent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_tile_position = tileMap.local_to_map(global_position)
	if current_tile_position != new_tile_position:
		current_tile_position = new_tile_position
		calculate_visible_tiles()


func calculate_visible_tiles():
	tiles_in_visible_range.clear()
	if directionState == DirectionState.up:
		for i in visible_range:
			if 1 != 0:
				tiles_in_visible_range[Vector2(current_tile_position.x, current_tile_position.y - i)] = null
				for j in range(
					-clamp(i, -visible_width, visible_width),
					clamp(i, -visible_width, visible_width) + 1
				):
					tiles_in_visible_range[Vector2(current_tile_position.x + j, current_tile_position.y - i)] = null
	if directionState == DirectionState.down:
		for i in visible_range:
			if 1 != 0:
				tiles_in_visible_range[Vector2(current_tile_position.x, current_tile_position.y + i)] = null
				for j in range(
					-clamp(i, -visible_width, visible_width),
					clamp(i, -visible_width, visible_width) + 1
				):
					tiles_in_visible_range[Vector2(current_tile_position.x + j, current_tile_position.y + i)] = null
	if directionState == DirectionState.left:
		for i in visible_range:
			if 1 != 0:
				tiles_in_visible_range[Vector2(current_tile_position.x - i, current_tile_position.y)] = null
				for j in range(
					-clamp(i, -visible_width, visible_width),
					clamp(i, -visible_width, visible_width) + 1
				):
					tiles_in_visible_range[Vector2(current_tile_position.x - i, current_tile_position.y + j)] = null
	if directionState == DirectionState.right:
		for i in visible_range:
			if 1 != 0:
				tiles_in_visible_range[Vector2(current_tile_position.x + i, current_tile_position.y)] = null
				for j in range(
					-clamp(i, -visible_width, visible_width),
					clamp(i, -visible_width, visible_width) + 1
				):
					tiles_in_visible_range[Vector2(current_tile_position.x + i, current_tile_position.y + j)] = null
	tiles_in_visible_range.erase(current_tile_position)
	gameLevel.draw_vision(self)


func moveTo(positionModifier):
	match ceil(rad_to_deg(positionModifier.angle())):
		float(180):
			directionState = DirectionState.left
		float(-90):
			directionState = DirectionState.up
		float(91):  # Don't ask, it just is
			directionState = DirectionState.down
		float(0):
			directionState = DirectionState.right

	var tileSize = 16
	var totalMovement = abs(positionModifier.x) + abs(positionModifier.y)
	var time = .25 * totalMovement

	$AnimationPlayer.play("walk")
	var tween = create_tween()
	await tween.tween_property(
		self,
		"position",
		Vector2(
			position.x + positionModifier.x * tileSize, position.y + positionModifier.y * tileSize
		),
		time
	)

	await get_tree().create_timer(time).timeout
	$AnimationPlayer.play("idle")


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
