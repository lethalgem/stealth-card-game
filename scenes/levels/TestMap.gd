class_name GameLevel
extends Node2D


@onready var global : GlobalClass = get_node("/root/Global")
@export var tileMap: TileMap
@export var badShort1 : BadShorty

var game: Game : 
	set(value): 
		game = value

var highlightingTile = preload("res://scenes/levels/highlighted_tile.tscn")
var confirmed_movement_tile_coords = []


var player;
func setPlayer(playerFromParent:Player):
	player = playerFromParent

func _ready():
	badShort1.setTileMap(tileMap)
	#badShort1.setPath([
		#Vector2(-1,0),
		#Vector2(-2,0),
		#Vector2(-3,0),
		#Vector2(-2,0),
		#Vector2(-1,0),
		#Vector2(0,0),
		#Vector2(1,0),
		#Vector2(2,0),
		#Vector2(3,0),
		#Vector2(2,0),
		#Vector2(1,0),
		#Vector2(0,0)
	#])
	
	#badShort1.setPath([
		#Vector2(0,-1),
		#Vector2(0,-2),
		#Vector2(0,-3),
		#Vector2(0,-2),
		#Vector2(0,-1),
		#Vector2(0,0),
		#Vector2(0,1),
		#Vector2(0,2),
		#Vector2(0,3),
		#Vector2(0,2),
		#Vector2(0,1),
		#Vector2(0,0)
	#])
	
	badShort1.setPath([
		
		Vector2(-1,0),
		Vector2(-2,0),
		Vector2(-3,0),
		Vector2(-3,-1),
		Vector2(-3,-2),
		Vector2(-3,-3),
		Vector2(-2,-3),
		Vector2(-1,-3),
		Vector2(0,-3),
		Vector2(0,-2),
		Vector2(0,-1),
		Vector2(0,0)
	])
	

func prep_for_movement(player_global_position: Vector2):
	print("prepping for movement")
	var tile_coords = tileMap.local_to_map(player_global_position)
	print(tile_coords)
	#var potential_movement_tiles = get_surrounding_tiles_in_range(tile_coords, 3)
	#var potential_movement_tiles = get_surrounding_tiles_in_range_New(tile_coords, 1, 3)
	get_surrounding_tiles_in_range(tile_coords, 6)
	var potential_movement_tiles = gatherAll()

	confirmed_movement_tile_coords = []
	for potential_tile_coords in potential_movement_tiles:
		print(potential_tile_coords)
		if tileMap.get_cell_tile_data(0, potential_tile_coords).get_custom_data("canMove"):
			print("can move here")
			confirmed_movement_tile_coords.append(potential_tile_coords)

	highlight_tiles(confirmed_movement_tile_coords)
	
	game.highlightFinished()


var highlightedTiles:Array = []
func highlight_tiles(tile_coords: PackedVector2Array):
	for coord in tile_coords:
		var unpacked_scene = highlightingTile.instantiate()
		var position_to_highlight = tileMap.map_to_local(coord)
		add_child(unpacked_scene)
		
		highlightedTiles.append(unpacked_scene)
				
		unpacked_scene.position = position_to_highlight
		
func removeHighlightedTiles():
	for highlightedTile in highlightedTiles:
		remove_child(highlightedTile)
	highlightedTiles = []
	

#func get_surrounding_tiles_in_range(current_coords: Vector2, distance: int) -> PackedVector2Array:
#var tiles = []
#for x in range(-distance, distance + 1):
#for y in range(-distance, distance + 1):
#if x!= 0 or y != 0:
#tiles.append(current_coords + Vector2(x, y))
##tiles.append(current_coords + Vector2(x - 1, y - 1))
#return tiles

var _possibleSpaces = {}
var _totalCount = 0



func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and global.currentState == global.States.waitingForTileClick:
		var mousePosition = event.position
		var tilePosition = tileMap.local_to_map(mousePosition)
		
		for confirmedTile in confirmed_movement_tile_coords:
		#if confirmed_movement_tile_coords.has(tilePosition):		
			if confirmedTile.x == tilePosition.x and confirmedTile.y == tilePosition.y:		
				if game.aboutToMoveCharacter():
					
					
					var playerTilePosition = tileMap.local_to_map(player.position)
					#var newPosition = Vector2((playerTilePosition.x - tilePosition.x)*16, (playerTilePosition.y - tilePosition.y)*16)
					var newPosition = Vector2(tilePosition.x*16 + 8, tilePosition.y*16 + 8)
					
					player.moveTo(newPosition)
					await get_tree().create_timer(.25).timeout
					
					removeHighlightedTiles()					
					game.characterFinishedMoving()


func get_surrounding_tiles_in_range(current_coords: Vector2, maxDistance: int):
	#for key in _possibleSpaces:
	#for innerKey in _possibleSpaces[key]:
	#_possibleSpaces[key].erase(innerKey)
	#_possibleSpaces.erase(key)
	_possibleSpaces = {}

	get_surrounding_tiles_in_range_recurse(current_coords, 0, maxDistance)


func get_surrounding_tiles_in_range_recurse(
	current_coords: Vector2, distance: int, maxDistance: int
):
	#var z = 0
	#if current_coords.x == 3 and current_coords.y == 7:
	#z = 1

	if distance > maxDistance:
		return

	_totalCount += 1
	print("XYZ")
	print(_totalCount)

	if distance != 0:
		if (
			not _possibleSpaces.has(current_coords.x)
			or not _possibleSpaces[current_coords.x].has(current_coords.y)
		):
			if not _possibleSpaces.has(current_coords.x):
				_possibleSpaces[current_coords.x] = {}

			_possibleSpaces[current_coords.x][current_coords.y] = true

		#TODO HERE for efficieny bug
		#else:
		#return

	var tiles = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			#print('here')
			#print(x)
			#print(y)
			if abs(x) == abs(y):
				continue

			if x != 0 or y != 0:
				var newPosition = current_coords + Vector2(x, y)
				if newPosition.x >= 0 and newPosition.y >= 0:
					if tileMap.get_cell_tile_data(0, newPosition).get_custom_data("canMove"):
						#if _possibleSpaces.has(newPosition.x) and _possibleSpaces[newPosition.x].has(newPosition.y):
						#continue
						#
						#elif not _possibleSpaces.has(newPosition.x):
						#_possibleSpaces[newPosition.x] = {}
						#
						#_possibleSpaces[newPosition.x][newPosition.y] = true
						#tiles.append(newPosition)

						tiles.append(newPosition)

	for tile in tiles:
		get_surrounding_tiles_in_range_recurse(tile, distance + 1, maxDistance)


func gatherAll():
	var tiles: Array = []
	for key in _possibleSpaces:
		for innerKey in _possibleSpaces[key]:
			tiles.append(Vector2(key, innerKey))

	return tiles
