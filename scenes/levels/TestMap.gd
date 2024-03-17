class_name GameLevel
extends Node2D

@onready var global: GlobalClass = get_node("/root/Global")
@export var tileMap: TileMap
@export var badShorty1: BadShorty
@export var badShorty2: BadShorty
@export var badShorty3: BadShorty
@export var badShorty4: BadShorty
@export var badShorty5: BadShorty
@export var badShorty6: BadShorty
@export var badShorty7: BadShorty
@export var badShorty8: BadShorty
@export var badShorty9: BadShorty
@export var badShorty10: BadShorty
@export var badShorty11: BadShorty
@export var badShorty12: BadShorty
@export var badShorty13: BadShorty
@export var badShorty14: BadShorty
@export var badShorty15: BadShorty
@export var badShorty16: BadShorty
@export var badShorty17: BadShorty
@export var badShorty18: BadShorty
@export var badShorty19: BadShorty
@export var badShorty20: BadShorty
@export var badShorty21: BadShorty

var game: Game:
	set(value):
		game = value

var highlightingTile = preload("res://scenes/levels/highlighted_tile.tscn")
var visionTile = preload("res://scenes/levels/VisionTile.tscn")
var confirmed_movement_tile_coords = []
var highlightedTiles: Array = []

var player

var firstMove = true


func badGuysMove():
	if firstMove:
		badShorty1.moveTo(Vector2(-10, 0))
		badShorty2.moveTo(Vector2(0, -5))
		badShorty3.moveTo(Vector2(7, 0))
		badShorty4.moveTo(Vector2(0, -5))
		badShorty5.moveTo(Vector2(10, 0))
		badShorty6.moveTo(Vector2(0, 4))
		badShorty7.moveTo(Vector2(-3, 0))
		badShorty8.moveTo(Vector2(6, 0))
		badShorty9.moveTo(Vector2(0, 8))
		badShorty10.moveTo(Vector2(-4, 0))
		badShorty11.moveTo(Vector2(6, 0))
		badShorty12.moveTo(Vector2(4, 0))
		badShorty13.moveTo(Vector2(0, 7))
		badShorty14.moveTo(Vector2(-7, 0))
		badShorty15.moveTo(Vector2(10, 0))
		badShorty16.moveTo(Vector2(-4, 0))
		badShorty17.moveTo(Vector2(0, 5))
		badShorty18.moveTo(Vector2(0, 6))
		badShorty19.moveTo(Vector2(5, 0))
		badShorty20.moveTo(Vector2(-4, 0))
		await badShorty21.moveTo(Vector2(0, 12))
		firstMove = false
	else:
		badShorty1.moveTo(Vector2(10, 0))
		badShorty2.moveTo(Vector2(0, 5))
		badShorty3.moveTo(Vector2(-7, 0))
		badShorty4.moveTo(Vector2(0, 5))
		badShorty5.moveTo(Vector2(-10, 0))
		badShorty6.moveTo(Vector2(0, -4))
		badShorty7.moveTo(Vector2(3, 0))
		badShorty8.moveTo(Vector2(-6, 0))
		badShorty9.moveTo(Vector2(0, -8))
		badShorty10.moveTo(Vector2(4, 0))
		badShorty11.moveTo(Vector2(-6, 0))
		badShorty12.moveTo(Vector2(-4, 0))
		badShorty13.moveTo(Vector2(0, -7))
		badShorty14.moveTo(Vector2(7, 0))
		badShorty15.moveTo(Vector2(-10, 0))
		badShorty16.moveTo(Vector2(4, 0))
		badShorty17.moveTo(Vector2(0, -5))
		badShorty18.moveTo(Vector2(0, -6))
		badShorty19.moveTo(Vector2(-5, 0))
		badShorty20.moveTo(Vector2(4, 0))
		await badShorty21.moveTo(Vector2(0, -12))
		firstMove = true

	game.badGuysFinished()


func setPlayer(playerFromParent: Player):
	player = playerFromParent


func _ready():
	badShorty1.gameLevel = self
	badShorty2.gameLevel = self
	badShorty3.gameLevel = self
	badShorty4.gameLevel = self
	badShorty5.gameLevel = self
	badShorty6.gameLevel = self
	badShorty7.gameLevel = self
	badShorty8.gameLevel = self
	badShorty9.gameLevel = self
	badShorty10.gameLevel = self
	badShorty11.gameLevel = self
	badShorty12.gameLevel = self
	badShorty13.gameLevel = self
	badShorty14.gameLevel = self
	badShorty15.gameLevel = self
	badShorty16.gameLevel = self
	badShorty17.gameLevel = self
	badShorty18.gameLevel = self
	badShorty19.gameLevel = self
	badShorty20.gameLevel = self
	badShorty21.gameLevel = self
	badShorty1.setTileMap(tileMap)
	badShorty2.setTileMap(tileMap)
	badShorty3.setTileMap(tileMap)
	badShorty4.setTileMap(tileMap)
	badShorty5.setTileMap(tileMap)
	badShorty6.setTileMap(tileMap)
	badShorty7.setTileMap(tileMap)
	badShorty8.setTileMap(tileMap)
	badShorty9.setTileMap(tileMap)
	badShorty10.setTileMap(tileMap)
	badShorty11.setTileMap(tileMap)
	badShorty12.setTileMap(tileMap)
	badShorty13.setTileMap(tileMap)
	badShorty14.setTileMap(tileMap)
	badShorty15.setTileMap(tileMap)
	badShorty16.setTileMap(tileMap)
	badShorty17.setTileMap(tileMap)
	badShorty18.setTileMap(tileMap)
	badShorty19.setTileMap(tileMap)
	badShorty20.setTileMap(tileMap)
	badShorty21.setTileMap(tileMap)

func showDemoFlower():
	var tween = create_tween()
	tween.tween_property(%DemoFlower, 'modulate:a', 1, .5)
	await tween.finished

func hideDemoFlower():
	var tween = create_tween()
	tween.tween_property(%DemoFlower, 'modulate:a', 0, .5)
	await tween.finished

func showFlower1():
	#%Flower1.modulate.a = 1
	var tween = create_tween()
	tween.tween_property(%Flower1, 'modulate:a', 1, .5)
	await tween.finished
	
func showFlower2():
	#%Flower2.modulate.a = 1
	var tween = create_tween()
	tween.tween_property(%Flower2, 'modulate:a', 1, .5)
	await tween.finished
	
func showFlower3():
	#%Flower3.modulate.a = 1
	var tween = create_tween()
	tween.tween_property(%Flower3, 'modulate:a', 1, .5)
	await tween.finished
	


func draw_vision(shorty: BadShorty):
	for child in shorty.confirmed_visible_tiles:
		remove_child(child)
	var potentially_visible_tiles = shorty.tiles_in_visible_range.keys()
	for tile_location in potentially_visible_tiles:
		var unpacked_scene = visionTile.instantiate()
		var position_to_draw = tileMap.map_to_local(tile_location)
		add_child(unpacked_scene)
		unpacked_scene.position = position_to_draw
		shorty.confirmed_visible_tiles.append(unpacked_scene)


func getOuterMost(playerCoordinated: Vector2, potential_movement_tiles: Array):
	var minMaxes = {}

	for tile in potential_movement_tiles:
		if not minMaxes.has(tile.y):
			minMaxes[tile.y] = {"min": tile.x, "max": tile.x}
		else:
			minMaxes[tile.y].min = min(tile.x, minMaxes[tile.y].min)
			minMaxes[tile.y].max = max(tile.x, minMaxes[tile.y].max)

	for key in minMaxes.keys():
		if minMaxes[key]["min"] >= playerCoordinated.x or minMaxes[key]["min"] == 0:
			minMaxes[key]["min"] = -100000
		if minMaxes[key]["max"] <= playerCoordinated.x:
			minMaxes[key]["max"] = 100000

	var rangeToIterate = range(len(potential_movement_tiles))
	rangeToIterate.reverse()
	for i in rangeToIterate:
		if (
			minMaxes[potential_movement_tiles[i].y]["min"] != potential_movement_tiles[i].x
			and minMaxes[potential_movement_tiles[i].y]["max"] != potential_movement_tiles[i].x
		):
			potential_movement_tiles.remove_at(i)

	return potential_movement_tiles


func prep_for_movement(player_global_position: Vector2, movement: int):
	var tile_coords = tileMap.local_to_map(player_global_position)
	get_surrounding_tiles_in_range(tile_coords, movement)
	var potential_movement_tiles = gatherAll()

	potential_movement_tiles = getOuterMost(tile_coords, potential_movement_tiles)

	confirmed_movement_tile_coords = []
	for potential_tile_coords in potential_movement_tiles:
		if tileMap.get_cell_tile_data(0, potential_tile_coords).get_custom_data("canMove"):
			confirmed_movement_tile_coords.append(potential_tile_coords)

	highlight_tiles(confirmed_movement_tile_coords)

	game.highlightFinished()


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


var _possibleSpaces = {}
var _totalCount = 0


func _input(event):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and global.currentState == global.States.waitingForTileClick
	):
		var mousePosition = event.position
		var tilePosition = tileMap.local_to_map(mousePosition)

		for confirmedTile in confirmed_movement_tile_coords:
			if confirmedTile.x == tilePosition.x and confirmedTile.y == tilePosition.y:
				if game.aboutToMoveCharacter():
					var playerTilePosition = tileMap.local_to_map(player.position)
					var newPosition = Vector2(tilePosition.x * 16 + 8, tilePosition.y * 16 + 8)

					player.moveTo(newPosition)
					await get_tree().create_timer(.25).timeout

					removeHighlightedTiles()
					game.characterFinishedMoving()


func get_surrounding_tiles_in_range(current_coords: Vector2, maxDistance: int):
	_possibleSpaces = {}
	_possibleSpaces[current_coords.x] = {}
	_possibleSpaces[current_coords.x][current_coords.y] = true

	get_surrounding_tiles_in_range_recurse(current_coords, current_coords, 0, maxDistance)


func get_surrounding_tiles_in_range_recurse(
	player_coords: Vector2, current_coords: Vector2, distance: int, maxDistance: int
):
	distance = abs(player_coords.x - current_coords.x) + abs(player_coords.y - current_coords.y)

	if distance > maxDistance:
		return

	_totalCount += 1

	var z = 4
	if current_coords.x == 7 and current_coords.y == 3:
		z = 3

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
			z = 4
			if current_coords.x == 8 and current_coords.y == 3:
				z = 3
			return

	var tiles = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			if abs(x) == abs(y):
				continue

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
