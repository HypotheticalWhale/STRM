extends Node2D
@onready var turn_timer = $UI/TurnTimerUI/TurnTimer
@export var GRID_SIZE = [20,10]
var tile_path = preload("res://Tile/TileNode.tscn")
var action_button = preload("res://UI/ActionButton.tscn")
var selected_tile
var valid_tiles = []
var tile_node
var tile_coords
var all_tiles = {}
var available_tiles = []
var available_attack_tiles = []
var starting_player = "P1"
var attacking = false
var mouse_relative_direction = "E"
var highlighted_tile 
var calc_direction
var button_pressed
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerData.create_units()
	spawn_tiles()
	spawn_units()
	turn_timer.start()
	if starting_player == "P1":
		turn_on_p1_ui()
	else:
		turn_on_p2_ui()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking and selected_tile:
		calc_direction = get_cursor_direction_relative_to_node(selected_tile)
		if calc_direction != mouse_relative_direction:
			mouse_relative_direction = calc_direction
			on_skill_pressed(button_pressed,calc_direction)

func spawn_units():
	var label_list = ["FirstExpContainer/FirstExp", "SecondExpContainer/SecondExp", "ThirdExpContainer/ThirdExp"]
	var label_count = 0
	var count = 2
	for unit in PlayerData.player1_units.values():
		add_child(unit)
		unit.set_sprite_blue()
		tile_coords = Vector2(2,count)*Globals.TILE_SIZE
		unit.global_position = tile_coords
		all_tiles[tile_coords].occupied_by["unit"] = unit
		unit.UI_EXP_LINK = "UI/Player1/MarginContainer/LabelContainer/"+label_list[label_count]		
		get_node("UI/Player1/MarginContainer/LabelContainer/"+label_list[label_count]).text = unit.CURRENT_JOB+" "
		count += 2
		label_count += 1
		
	label_count = 0
	count = 2
	for unit in PlayerData.player2_units.values():
		add_child(unit)
		unit.set_sprite_red()		
		tile_coords = Vector2(GRID_SIZE[0]-1,count)*Globals.TILE_SIZE
		unit.global_position = tile_coords
		all_tiles[tile_coords].occupied_by["unit"] = unit
		unit.UI_EXP_LINK = "UI/Player2/MarginContainer/LabelContainer/"+label_list[label_count]
		get_node("UI/Player2/MarginContainer/LabelContainer/"+label_list[label_count]).text = unit.CURRENT_JOB +" "
		count += 2
		label_count += 1
		

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
				if (x_tile == 2 or x_tile == GRID_SIZE[0]-1) and y_tile == round(float(GRID_SIZE[1])/2):
					tile_node.add_terrain("throne")
				else:
					tile_node.add_terrain("marble")
			else:
				tile_node.add_terrain("garden")

func get_occupied_tiles():
	var occupied_tiles = []
	for tile in all_tiles.values():
		if tile.occupied_by["unit"] != null:
			occupied_tiles.append(tile)
	return occupied_tiles

		
func turn_on_p1_ui():
	$UI/Player1.visible = true
	$UI/Player2.visible = false

func turn_on_p2_ui():
	$UI/Player1.visible = false
	$UI/Player2.visible = true

func show_select_menu(menu_position,tile_node):
	hide_action_buttons()	
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

func show_action_buttons():
	$SelectOptions/PanelContainer/HBoxContainer/ActionButtons.visible = true

func hide_action_buttons():
	$SelectOptions/PanelContainer/HBoxContainer/ActionButtons.visible = false
	

func disable_move_button():
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/MoveButton.disabled = true
	
func disable_action_button():
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/ActionButton.disabled = true
	
func highlight_available_tiles(available_tiles_coords):
	clear_available_tiles()
	clear_available_attack_tiles()
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
	
func clear_available_attack_tiles():
	for grid_pos in available_attack_tiles:
		all_tiles[grid_pos].hide_available_attack_tile()
		all_tiles[grid_pos].hide_target_tile()
	available_attack_tiles = []


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
	hide_action_buttons()
	hide_select_menu()
	
func _on_end_button_pressed():
	turn_timer.stop()	
	_on_turn_timer_timeout()
	turn_timer.start()
	
func _on_turn_timer_timeout():
	hide_info_menu()
	hide_select_menu()	
	clear_available_attack_tiles()
	clear_available_tiles()
	attacking = false
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/MoveButton.disabled = false
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/ActionButton.disabled = false
	Globals.TAKENACTION = ""	
	await Globals.toggle_player_turn()
	if Globals.WHOSTURNISIT == "P1":
		turn_on_p1_ui()
	if Globals.WHOSTURNISIT == "P2":		
		turn_on_p2_ui()
	
	# show reminder for next players turn
	get_node("UI/NextPlayerReady").visible = true
	get_node("UI/NextPlayerReady").text = Globals.WHOSTURNISIT + "'s turn. Click to start."
	get_tree().paused = true
	
func _on_action_button_pressed():
	var button
	var action_button_container = $SelectOptions/PanelContainer/HBoxContainer/ActionButtons
	for child in action_button_container.get_children():
		child.queue_free()
	for action in selected_tile.occupied_by["unit"].ACTIONS:
		button = action_button.instantiate()
		button.text = action
		button.skill_owner = selected_tile.occupied_by["unit"]
		button.skill_name = action
		action_button_container.add_child(button)
		if Globals.WHOSTURNISIT == "P2":
			button.pressed.connect(on_skill_pressed.bind(button,"W"))
		else:
			button.pressed.connect(on_skill_pressed.bind(button,"E"))
	show_action_buttons()

func on_skill_pressed(button,direction):
	button_pressed = button
	attacking = true
	var attack_coords = Globals.rotate_skill_to_direction(direction,button.skill_name)
	var grid_pos
	clear_available_tiles()
	clear_available_attack_tiles()
	for tile in attack_coords:
		grid_pos = selected_tile.global_position + tile * Globals.TILE_SIZE
		if grid_pos not in valid_tiles:
			continue
		if not all_tiles[grid_pos].occupied_by["unit"]:
			all_tiles[grid_pos].show_available_attack_tile()
			available_attack_tiles.append(grid_pos)		
			continue
		#if Globals.WHOSTURNISIT == all_tiles[grid_pos].occupied_by["unit"].TEAM:
			#all_tiles[grid_pos].show_target_tile()
			#available_attack_tiles.append(grid_pos)		
		all_tiles[grid_pos].show_target_tile()
		available_attack_tiles.append(grid_pos)	
	hide_action_buttons()
	hide_select_menu()
			
func get_cursor_direction_relative_to_node(node: Node2D) -> String:
	if not highlighted_tile:
		return mouse_relative_direction
	var cursor_position = highlighted_tile.global_position
	var node_position = node.global_position
	var direction = ""
	var dx = cursor_position.x - node_position.x
	var dy = cursor_position.y - node_position.y 
	if abs(dx) > abs(dy):
		if dx > 0:
			direction = "E"
		else:
			direction = "W"
	else:
		if dy > 0:
			direction = "S"
		else:
			direction = "N"
	return direction
