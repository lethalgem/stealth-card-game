class_name GameLevel
extends Node2D

@export var tileMap: TileMap

var highlightingTile = preload("res://scenes/levels/highlighted_tile.tscn")


func prep_for_movement(player_global_position: Vector2):
	print("prepping for movement")
	var tile_coords = tileMap.local_to_map(player_global_position)
	print(tile_coords)
	var potential_movement_tiles = get_surrounding_tiles_in_range(tile_coords, 1)
	var confirmed_movement_tile_coords = []
	for potential_tile_coords in potential_movement_tiles:
		print(potential_tile_coords)
		if tileMap.get_cell_tile_data(0, potential_tile_coords).get_custom_data("canMove"):
			print("can move here")
			confirmed_movement_tile_coords.append(potential_tile_coords)
	highlight_tiles(confirmed_movement_tile_coords)


func highlight_tiles(tile_coords: PackedVector2Array):
	for coord in tile_coords:
		var unpacked_scene = highlightingTile.instantiate()
		var position_to_highlight = tileMap.map_to_local(coord)
		add_child(unpacked_scene)
		unpacked_scene.position = position_to_highlight


func get_surrounding_tiles_in_range(current_coords: Vector2, range: int) -> PackedVector2Array:
	var tiles = []
	for x in range + 2:
		print(x)
		for y in range + 2:
			tiles.append(current_coords + Vector2(x - 1, y - 1))
	return tiles
