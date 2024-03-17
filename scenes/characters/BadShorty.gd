class_name BadShorty

extends Sprite2D

@export var visible_range: int = 6
@export var visible_width: int = 2  # *2

enum DirectionState { left, right, up, down }
@export var directionState = DirectionState.left

@onready var movement_audio_player: AudioStreamPlayer2D = %MovementAudioPlayer

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
	var modifiedPosition = Vector2(global_position.x, global_position.y + 3)
	var new_tile_position = tileMap.local_to_map(modifiedPosition)
	#var new_tile_position = tileMap.local_to_map(global_position)
	if current_tile_position != new_tile_position:
		current_tile_position = new_tile_position
		calculate_visible_tiles()
		
		prep_for_movement(new_tile_position, 5)
		var z = confirmed_movement_tile_coords 
		var x = 3
		var visibleKeys = tiles_in_visible_range.keys()
		#visibleKeys.reverse()
		for key in visibleKeys:
			var a1 = confirmed_movement_tile_coords.has(key.x)
			var a2 = confirmed_movement_tile_coords[key.x].has(key.y) if a1 else false
			if not a1 or not a2:
				tiles_in_visible_range.erase(key)
		
		var e = 2
		gameLevel.draw_vision(self)
		

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
	#gameLevel.draw_vision(self)


func moveTo(positionModifier):
	# MB only x or y will be non-zero, method below is more efficient and non-float rounding
	# compared to rad / trig etc. 
	#match ceil(rad_to_deg(positionModifier.angle())):
		#float(180):
			#directionState = DirectionState.left
		#float(-90):
			#directionState = DirectionState.up
		#float(91):  # Don't ask, it just is
			#directionState = DirectionState.down
		#float(0):
			#directionState = DirectionState.right
			
	if positionModifier.x > 0:
		directionState = DirectionState.right
	elif positionModifier.x < 0:
		directionState = DirectionState.left
	elif positionModifier.y > 0:
		directionState = DirectionState.down		
	elif positionModifier.y < 0:
		directionState = DirectionState.up

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

	movement_audio_player.play(random.randf_range(0, 2))

	await get_tree().create_timer(time).timeout
	$AnimationPlayer.play("idle")
	movement_audio_player.stop()
















var confirmed_movement_tile_coords = {}

func prep_for_movement(tile_coords: Vector2, movement: int):
	#var tile_coords = tileMap.local_to_map(player_global_position)
	get_surrounding_tiles_in_range(tile_coords, movement)
	var potential_movement_tiles = gatherAll()

	#potential_movement_tiles = getOuterMost(tile_coords, potential_movement_tiles)

	confirmed_movement_tile_coords = {}
	for potential_tile_coords in potential_movement_tiles:
		var thisTile = tileMap.get_cell_tile_data(0, potential_tile_coords)
		if thisTile != null and thisTile.get_custom_data("canMove"):
			if not confirmed_movement_tile_coords.has(potential_tile_coords.x):
				confirmed_movement_tile_coords[potential_tile_coords.x] = {}
			confirmed_movement_tile_coords[potential_tile_coords.x][potential_tile_coords.y] = true
			#confirmed_movement_tile_coords.append(potential_tile_coords)




var _possibleSpaces = {}
var _totalCount = 0


func get_surrounding_tiles_in_range(current_coords: Vector2, maxDistance: int):
	_possibleSpaces = {}
	_possibleSpaces[current_coords.x] = {}
	_possibleSpaces[current_coords.x][current_coords.y] = true

	get_surrounding_tiles_in_range_recurse(current_coords, current_coords, 0, maxDistance)


func get_surrounding_tiles_in_range_recurse(
	player_coords: Vector2, current_coords: Vector2, distance: int, maxDistance: int
):
	#distance = abs(player_coords.x - current_coords.x) + abs(player_coords.y - current_coords.y)
	distance = max(abs(player_coords.x - current_coords.x), abs(player_coords.y - current_coords.y))

	if distance > maxDistance:
		return

	_totalCount += 1

	#var z = 4
	#if current_coords.x == 7 and current_coords.y == 3:
		#z = 3

	if distance != 0:
		if (
			not _possibleSpaces.has(current_coords.x)
			or not _possibleSpaces[current_coords.x].has(current_coords.y)
		):
			if not _possibleSpaces.has(current_coords.x):
				_possibleSpaces[current_coords.x] = {}

			_possibleSpaces[current_coords.x][current_coords.y] = true

		#TODO HERE for efficiency bug
		else:
			#z = 4
			#if current_coords.x == 8 and current_coords.y == 3:
				#z = 3
			return

	var tiles = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			#if abs(x) == abs(y):
				#continue

			if x != 0 or y != 0:
				var newPosition = current_coords + Vector2(x, y)
				if newPosition.x >= 0 and newPosition.y >= 0:
					var tileData = tileMap.get_cell_tile_data(0, newPosition)
					if tileData != null and tileData.get_custom_data("canMove"):
						tiles.append(newPosition)

	for tile in tiles:
		get_surrounding_tiles_in_range_recurse(player_coords, tile, distance + 1, maxDistance)


func gatherAll():
	var tiles: Array = []
	for key in _possibleSpaces:
		for innerKey in _possibleSpaces[key]:
			tiles.append(Vector2(key, innerKey))

	return tiles
	
	
	
	
	



















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
