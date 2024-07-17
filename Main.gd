extends Node2D

@export var GRID_SIZE = [20,10]
var tile_path = preload("res://Tile/TileNode.tscn")
var selected_tile
var valid_tiles = []
var tile_node
var tile_coords
var all_tiles = {}
var available_tiles = []
var starting_player = "P1"
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerData.create_units()
	spawn_tiles()
	spawn_units()
	$UI/TurnTimerUI/TurnTimer.start()
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
		all_tiles[tile_coords].occupied_by["unit"] = unit
		count += 1
		
	count = 2
	for unit in PlayerData.player2_units.values():
		add_child(unit)
		unit.set_sprite_red()		
		tile_coords = Vector2(GRID_SIZE[0]-1,count)*Globals.TILE_SIZE
		unit.global_position = tile_coords
		all_tiles[tile_coords].occupied_by["unit"] = unit
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
			valid_tiles.append(tile_coords)
			
			# adding terrain
			var manor_length : int = GRID_SIZE[0] * 0.4
			if x_tile <= manor_length or x_tile > (GRID_SIZE[0] - manor_length):
				print("y_tile: ", y_tile)
				print(round(float(GRID_SIZE[1])/2))
				print("x_tile: ", x_tile)
				print(GRID_SIZE[0])
				if (x_tile == 2 or x_tile == GRID_SIZE[0]-1) and y_tile == round(float(GRID_SIZE[1])/2):
					print("entered")
					tile_node.add_terrain("throne")
				else:
					tile_node.add_terrain("marble")
			else:
				tile_node.add_terrain("garden")

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

func show_select_menu(menu_position,tile_node):
	selected_tile = tile_node
	$SelectOptions.visible = true
	$SelectOptions.global_position = menu_position
	hide_info_menu()
	
func show_info_menu(menu_position,tile_node):
	selected_tile = tile_node	
	$NotYourOptions.visible = true
	$NotYourOptions.global_position = menu_position
	hide_select_menu()
	
func hide_select_menu():
	$SelectOptions.visible = false

func hide_info_menu():
	$NotYourOptions.visible = false

func highlight_available_tiles(available_tiles_coords):
	clear_available_tiles()
	var grid_pos
	for tile_coords in available_tiles_coords:
		grid_pos = tile_coords*Globals.TILE_SIZE
		if grid_pos not in valid_tiles:
			continue
		if all_tiles[grid_pos].is_empty_tile():
			continue
		available_tiles.append(grid_pos)		
		all_tiles[grid_pos].toggle_available_tile()

func clear_available_tiles():
	for grid_pos in available_tiles:
		all_tiles[grid_pos].toggle_available_tile()
	available_tiles = []


func get_available_coordinates(start_pos: Vector2, movement_range: int):
	var available_coords = []
	var queue = []
	var visited = {}

	queue.append({"pos": start_pos, "moves": 0})
	visited[start_pos] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		var current_pos = current["pos"]
		var current_moves = current["moves"]

		# If the current moves exceed the movement range, continue
		if current_moves > movement_range:
			continue

		# Add the current position to the available coordinates
		available_coords.append(current_pos)

		# Define possible moves (up, down, left, right)
		var possible_moves = [
			Vector2(0, -1), # Up
			Vector2(0, 1),  # Down
			Vector2(-1, 0), # Left
			Vector2(1, 0)   # Right
		]

		for move in possible_moves:
			var new_pos = current_pos + move

			# Check if the new position is already visited
			if not visited.has(new_pos):
				visited[new_pos] = true
				queue.append({"pos": new_pos, "moves": current_moves + 1})

	return available_coords


func _on_move_button_pressed():
	highlight_available_tiles(get_available_coordinates(selected_tile.global_position/Globals.TILE_SIZE,selected_tile.occupied_by["unit"].MOVEMENT)) 
	
