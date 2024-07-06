extends Node2D

@export var GRID_SIZE = [20,10]
var tile_path = preload("res://Tile/TileNode.tscn")
var tile_node
var tile_coords
var all_tiles = {}
var starting_player = "P1"
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerData.create_units()
	spawn_tiles()
	spawn_units()
	$TurnTimer.start()
	if starting_player == "P1":
		turn_on_p1_ui()
	else:
		turn_on_p2_ui()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_units():
	var count = 2
	for unit in PlayerData.player1_units.values():
		add_child(unit)
		unit.set_sprite_blue()
		tile_coords = Vector2(2,count)*Globals.TILE_SIZE
		unit.global_position = tile_coords
		all_tiles[tile_coords].occupied_by = unit
		count += 1
		
	count = 2
	for unit in PlayerData.player2_units.values():
		add_child(unit)
		unit.set_sprite_red()		
		tile_coords = Vector2(GRID_SIZE[0]-1,count)*Globals.TILE_SIZE
		unit.global_position = tile_coords
		all_tiles[tile_coords].occupied_by = unit		
		count += 1

func spawn_tiles():
	for x_tile in range(2,GRID_SIZE[0]):
		for y_tile in range(2,GRID_SIZE[1]):
			tile_node = tile_path.instantiate()
			add_child(tile_node)
			tile_coords = Vector2(x_tile,y_tile)*Globals.TILE_SIZE
			tile_node.tile_coordinates = tile_coords
			tile_node.global_position = tile_coords
			all_tiles[tile_coords] = tile_node

func get_occupied_tiles():
	var occupied_tiles = []
	for tile in all_tiles.values():
		if tile.occupied_by != null:
			occupied_tiles.append(tile)
	return occupied_tiles


func _on_turn_timer_timeout():
	await Globals.toggle_player_turn()
	if Globals.WHOSTURNISIT == "P1":
		turn_on_p1_ui()
	if Globals.WHOSTURNISIT == "P2":		
		turn_on_p2_ui()
		
func turn_on_p1_ui():
	$UI/Player1.visible = true
	$UI/Player2.visible = false

func turn_on_p2_ui():
	$UI/Player1.visible = false
	$UI/Player2.visible = true
