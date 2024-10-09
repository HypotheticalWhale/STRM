extends Node2D
@onready var turn_timer = $UI/TurnTimerUI/TimerContainer/TurnTimer
@export var GRID_SIZE = [20,10]

var tile_path = preload("res://Tile/TileNode.tscn")
var action_button = preload("res://UI/ActionButton.tscn")
var selected_tile
var valid_tiles = []
var tile_node
var tile_coords
var all_tiles = {}
var available_tiles = []
var displace_target_tiles = []	# for the displace active
var displace_destination_coords = []	# grid pos of displace destinations
var target_terrain_info = {} 	# e.g. target_terrain_info = { Vector2(32, 64): "tea table", Vector2(64, 64)": "Chair" }

# Structure of available_attack_tiles
## key = grid_pos, value = dictionary of skill details. 
## e.g. available_attack_tiles = {
##	Vector2(1,0): {
##		"damage": 5,
##	}
##}
var available_attack_tiles: Dictionary
#
var astar = AStarGrid2D.new()

var starting_player = "P1"
var attacking = false
var moving  = false
var mouse_relative_direction = "E"
var previous_highlighted_tile
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
	astar.cell_size = Vector2i(Globals.TILE_SIZE,Globals.TILE_SIZE)
	astar.region = Rect2(Vector2(2,2),Vector2(GRID_SIZE[0],GRID_SIZE[1]))
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	for tile in get_occupied_tiles():
		if tile.occupied_by["unit"].TEAM != Globals.WHOSTURNISIT:
			astar.set_point_solid(tile.global_position/Globals.TILE_SIZE,true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attacking and selected_tile:
		calc_direction = get_cursor_direction_relative_to_node(selected_tile)
		if calc_direction != mouse_relative_direction:
			mouse_relative_direction = calc_direction
			on_skill_pressed(button_pressed,calc_direction)
	if moving:
		if previous_highlighted_tile != highlighted_tile and highlighted_tile.available_tile.visible:
			previous_highlighted_tile = highlighted_tile
			$MovementArrow.clear_points()
			for point in astar.get_id_path(selected_tile.global_position/Globals.TILE_SIZE,highlighted_tile.global_position/Globals.TILE_SIZE):
				$MovementArrow.add_point(point*Globals.TILE_SIZE)
	
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

func reset_units():
	var count = 2
	for unit in PlayerData.player1_units.values():
		tile_coords = Vector2(2,count)*Globals.TILE_SIZE
		all_tiles[unit.global_position].occupied_by["unit"] = null # set the previous tile to null 
		count += 2
		unit.global_position = tile_coords
		all_tiles[tile_coords].occupied_by["unit"] = unit # set the new tile to the unit
	count = 2
	for unit in PlayerData.player2_units.values():
		tile_coords = Vector2(GRID_SIZE[0]-1,count)*Globals.TILE_SIZE
		all_tiles[unit.global_position].occupied_by["unit"] = null
		unit.global_position = tile_coords
		all_tiles[tile_coords].occupied_by["unit"] = unit
		count += 2		
	
	
func spawn_tiles():
	var throne_count = true
	
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
					if throne_count:
						tile_node.occupied_by["terrain"].WHOSTHRONEISIT = "P1"
						throne_count = false
					else:
						tile_node.occupied_by["terrain"].WHOSTHRONEISIT = "P2"
				else:
					if (x_tile >= 2 and x_tile < 5) or (x_tile < GRID_SIZE[0] and x_tile >= GRID_SIZE[0]-3):
						tile_node.add_terrain("marble")
					else:
						tile_node.add_terrain("lobby")						
						
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

func enable_move_button():
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/MoveButton.disabled = false
	
func disable_action_button():
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/ActionButton.disabled = true

func enable_action_button():
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/ActionButton.disabled = false
	
func highlight_available_tiles(available_tiles_coords):
	clear_available_tiles()
	clear_available_attack_tiles()
	moving = true
	var grid_pos
	
	for tile_coords in available_tiles_coords:
		grid_pos = tile_coords*Globals.TILE_SIZE
		if grid_pos not in valid_tiles:
			continue
		if all_tiles[grid_pos].is_empty_tile():
			continue
		if len(astar.get_id_path(selected_tile.global_position/Globals.TILE_SIZE,tile_coords)) <= selected_tile.occupied_by["unit"].MOVEMENT+1:
			available_tiles.append(grid_pos)
			all_tiles[grid_pos].toggle_available_tile()

func clear_available_tiles():
	$MovementArrow.clear_points()
	
	for grid_pos in available_tiles:
		all_tiles[grid_pos].toggle_available_tile()
	available_tiles = []
	moving = false
	
func clear_available_attack_tiles():
	for grid_pos in available_attack_tiles:
		all_tiles[grid_pos].hide_available_attack_tile()
		all_tiles[grid_pos].hide_target_tile()
		all_tiles[grid_pos].hide_target_terrain_tile()
		all_tiles[grid_pos].hide_destination_tile()
		# reset any modulates (such as from sweet spot)
		all_tiles[grid_pos].modulate = Color(1,1,1)
	available_attack_tiles = {}


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
	moving = false
	$MovementArrow.clear_points()
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/MoveButton.disabled = false
	$SelectOptions/PanelContainer/HBoxContainer/SelectButtons/ActionButton.disabled = false
	Globals.TAKENACTION = null
	
	# track status ailment durations
	var current_turn_units = []
	if Globals.WHOSTURNISIT == "P1":
		current_turn_units = PlayerData.player1_units
	if Globals.WHOSTURNISIT == "P2":
		current_turn_units = PlayerData.player2_units
	# -1 to all the status ailment counters
	for unit in current_turn_units.values():
		unit.disabled_turns_left = max(unit.disabled_turns_left - 1, 0)
		unit.immobilized_turns_left = max(unit.immobilized_turns_left - 1, 0)
		
	await Globals.toggle_player_turn()
	if Globals.WHOSTURNISIT == "P1":
		turn_on_p1_ui()
	if Globals.WHOSTURNISIT == "P2":		
		turn_on_p2_ui()
	for tile in get_occupied_tiles():
			if tile.occupied_by["unit"].TEAM != Globals.WHOSTURNISIT:
				astar.set_point_solid(tile.global_position/Globals.TILE_SIZE,true)
			else:
				astar.set_point_solid(tile.global_position/Globals.TILE_SIZE,false)
				
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
	clear_available_tiles()
	clear_available_attack_tiles()
	target_terrain_info = {}
	
	##################### telegraphing the terrain to be changed ##################
	if Globals.skills[button.skill_name]["optional effects"].has("change terrain"):
		# change_terrain_info example = [
		#	["tea table", [Vector2(1,0)],
		#	["Chairs", [Vector2(1,1), Vector2(1,-1)]
		#]
		var change_terrain_info = Globals.skills[button.skill_name]["optional effects"]["change terrain"]
		for terrain in change_terrain_info:
			var terrain_type = terrain[0]
			var terrain_target_shape = terrain[1]
			var rotated_coords = Globals.rotate_coords_to_direction(direction, terrain_target_shape)
			var absolute_coords = []
			for coord in rotated_coords:
				absolute_coords.append((coord*Globals.TILE_SIZE + selected_tile.global_position)/Globals.TILE_SIZE)
			for coord in absolute_coords:
				var new_position = coord * Globals.TILE_SIZE
				# invalid tiles cannot have their terrain changed
				if new_position not in valid_tiles:
					continue
				# tiles occupied by units cannot have their terrain changed
				if all_tiles[new_position].occupied_by["unit"]:
					continue
				
				target_terrain_info[new_position] = terrain_type
				await all_tiles[new_position].show_target_terrain_tile()
			
	##################### telegraphing the displace destination tile ##################
	# dont judge
	# for displace skills, we gotta telegraph the displacement destinations to the player
	# case 1: destinations in invalid tiles: ignore
	# case 1: destinations on occupied tile: ignore
	# case 3: destinations on empty tile: show character outline to indicate destination
	displace_destination_coords = []
	if Globals.skills[button.skill_name]["optional effects"].has("displace"):
		var rotated_coords = Globals.rotate_coords_to_direction(direction, Globals.skills[button.skill_name]["optional effects"]["displace"])
		for coord in rotated_coords:
			displace_destination_coords.append((selected_tile.global_position + coord * Globals.TILE_SIZE)/Globals.TILE_SIZE)
		# find the impossible destinations
		var impossible_destinations = []
		for coord in displace_destination_coords:
			var new_position = coord * Globals.TILE_SIZE
			if new_position not in valid_tiles:
				impossible_destinations.append(coord)
				continue
			if all_tiles[new_position].occupied_by["unit"]:
				impossible_destinations.append(coord)
				continue
			if not all_tiles[new_position].occupied_by["unit"]:
				await all_tiles[new_position].show_destination_tile()
		# ensure that destinations do not include impossible destinations
		for coord in impossible_destinations:
			displace_destination_coords.erase(coord)
				
	################################# telegraphing the attack shape ##############################
	var attack_coords = []
	if len(Globals.skills[button.skill_name]["shape"]) == 0:
		for x in range(GRID_SIZE[0]*2):
			for y in range(GRID_SIZE[1]*2):
				attack_coords.append(Vector2(x-GRID_SIZE[0],y-GRID_SIZE[1]))
	else:
		attack_coords = Globals.rotate_coords_to_direction(direction,Globals.skills[button.skill_name]["shape"])
	
	##################### passing attack_info into each available/targeted tile ##################
	var grid_pos
	displace_target_tiles = []
	for tile in attack_coords:
		grid_pos = selected_tile.global_position + tile * Globals.TILE_SIZE
		if grid_pos not in valid_tiles:
			continue
			
		if not all_tiles[grid_pos].occupied_by["unit"]:
			# dash skills don't allow you to select empty squares
			if Globals.skills[button.skill_name]["optional effects"].has("dash"):
				pass
			else:
				all_tiles[grid_pos].show_available_attack_tile()
			
		else: 
			all_tiles[grid_pos].show_target_tile()
			if Globals.skills[button.skill_name]["optional effects"].has("displace"):
				displace_target_tiles.append(grid_pos)
				
		
		# pass in owner, damage and effects of a skill to each tile
		available_attack_tiles[grid_pos] = {}
		available_attack_tiles[grid_pos]["who is hitting"] = button.skill_owner
		
		# calculate damage and add it to available_attack_tiles[grid_pos]
		var base_damage = button.skill_owner.DAMAGE
		var skill_damage_multiplier = Globals.skills[button.skill_name]["damage multiplier"]
		var sweet_spot_damage_multiplier = 1.0
		if Globals.skills[button.skill_name]["optional effects"].has("sweet spot"):
			var sweet_spot_tile = Globals.rotate_coords_to_direction(direction, [Globals.skills[button.skill_name]["optional effects"]["sweet spot"]])[0]
			if tile == sweet_spot_tile:
				# modulate tile to show sweet spot
				all_tiles[button.skill_owner.global_position + tile*Globals.TILE_SIZE].modulate = Color(1,0.6,0.6)
				sweet_spot_damage_multiplier = 2.0
		if len(button.skill_owner.PASSIVES) > 0 and all_tiles[grid_pos].occupied_by["terrain"].type == "Garden": #gardener passive
			for passive in button.skill_owner.PASSIVES:
				if passive == "Green Thumbs":
					var passive_damage_multiplier = Globals.passives[passive]["damage multiplier"]
					available_attack_tiles[grid_pos]["damage"] = base_damage * skill_damage_multiplier * sweet_spot_damage_multiplier * passive_damage_multiplier
		else:
			available_attack_tiles[grid_pos]["damage"] = base_damage * skill_damage_multiplier * sweet_spot_damage_multiplier
		
		# account for knockback and add it to available_attack_tiles[grid_pos]
		if Globals.skills[button.skill_name]["optional effects"].has("knockback"):
			available_attack_tiles[grid_pos]["knockback"] = {}
			available_attack_tiles[grid_pos]["knockback"]["direction"] = direction
			available_attack_tiles[grid_pos]["knockback"]["distance"] = Globals.skills[button.skill_name]["optional effects"]["knockback"]
			 
		# pass in disable duration to tilenode
		if Globals.skills[button.skill_name]["optional effects"].has("disable"):
			available_attack_tiles[grid_pos]["disable"] = Globals.skills[button.skill_name]["optional effects"]["disable"]
		
		# pass in immobilize duration to tilenode
		if Globals.skills[button.skill_name]["optional effects"].has("immobilize"):
			available_attack_tiles[grid_pos]["immobilize"] = Globals.skills[button.skill_name]["optional effects"]["immobilize"]
		
		# pass in dash to tilenode
		if Globals.skills[button.skill_name]["optional effects"].has("dash"):
			if not all_tiles[grid_pos].occupied_by["unit"]:
				pass
			else:
				available_attack_tiles[grid_pos]["dash"] = {}
				# get the destination square by finding an adjacent square to the target nearest to skill owner
				var coords_adjacent_to_target = []
				for direction_vector in [Vector2(1,0), Vector2(0,-1), Vector2(-1,0), Vector2(0,1)]:
					coords_adjacent_to_target.append(grid_pos + direction_vector*Globals.TILE_SIZE)
				# initialize destination with an impossible coordinate.
				var destination: Vector2 = Vector2(99999, 99999)
				var min: float = 99999
				for coord in coords_adjacent_to_target:
					if coord.distance_squared_to(button.skill_owner.global_position) < min:
						min = coord.distance_squared_to(button.skill_owner.global_position)
						destination = coord
				# assertion error here means that a suitable destination was not found.
				assert(destination != Vector2(99999, 99999))
				available_attack_tiles[grid_pos]["dash"]["destination"] = destination
		
		# pass in destinations of targets to tilenode
		if Globals.skills[button.skill_name]["optional effects"].has("displace"):
			available_attack_tiles[grid_pos]["displace"] = {}
			available_attack_tiles[grid_pos]["displace"]["destinations"] = displace_destination_coords
		

			
	##################### choosing units to be displaced ##################
	# remove random units from displace targets (gotta choose only 2 out of 5)
	if Globals.skills[button.skill_name]["optional effects"].has("displace"):
		randomize()
		displace_target_tiles.shuffle()
		var num_displace_destination_tiles = len(displace_destination_coords)
		if len(displace_target_tiles) >= num_displace_destination_tiles:	# if enough targets to displace
			displace_target_tiles = displace_target_tiles.slice(0, num_displace_destination_tiles)
		if len(displace_target_tiles) < num_displace_destination_tiles:	# if not enough targets to displace
			displace_target_tiles = displace_target_tiles
	
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
