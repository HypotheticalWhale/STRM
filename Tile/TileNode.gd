extends Area2D

var has_object : bool = false
var tile_coordinates
var occupied_by = {
	"unit" : null,
	"terrain": null,
}
@onready var highlighted_tile = $Selected
@onready var available_tile = $Available
@onready var available_attack_tile = $AvailableAttack
@onready var target_tile = $Target
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_mouse_entered():
	if not (occupied_by["unit"] and get_parent().attacking):
		highlighted_tile.visible = true
	get_parent().highlighted_tile = self

func _on_mouse_exited():
	highlighted_tile.visible = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Globals.show_tile_info(self)
		if occupied_by["unit"] and Globals.WHOSTURNISIT != occupied_by["unit"].TEAM and not get_parent().attacking:
			get_parent().attacking = false						
			get_parent().show_info_menu(global_position,self)			
			get_parent().clear_available_tiles()			
			get_parent().clear_available_attack_tiles()			
			return
			
###################################### if player has moved with or used an action ######################################
		# move already, now want to attack
		if Globals.TAKENACTION and (available_attack_tile.visible == true or target_tile.visible == true):
			# look for any units on this tilenode, and trigger their get_hit()
			for tile in get_parent().available_attack_tiles:
				var attack_tile_info = get_parent().available_attack_tiles[tile]
				if get_parent().all_tiles[tile].occupied_by["unit"]:
					# attack_tile_info contains a dictionary with various attack details such as damage
					get_parent().all_tiles[tile].occupied_by["unit"].get_hit(attack_tile_info)
			if get_parent().available_attack_tiles[tile_coordinates].has("dash"):
				var dash_destination = get_parent().available_attack_tiles[tile_coordinates]["dash"]["destination"]
				get_parent().selected_tile.occupied_by["unit"].warp_to(dash_destination)
			get_parent().attacking = false
			get_parent().clear_available_tiles()			
			get_parent().clear_available_attack_tiles()
			get_parent().hide_select_menu()
			get_parent().hide_info_menu()
			get_parent().disable_action_button()
			await Globals.complete_fight_quest(Globals.TAKENACTION)
			return
			
		# attack already, now want to move
		if Globals.TAKENACTION and available_tile.visible == true:
			occupied_by["unit"] = get_parent().selected_tile.occupied_by["unit"]
			get_parent().selected_tile.occupied_by["unit"].global_position = global_position
			get_parent().selected_tile.occupied_by["unit"] = null
			get_parent().disable_move_button()
			get_parent().clear_available_tiles()			
			get_parent().clear_available_attack_tiles()
			get_parent().hide_select_menu()
			get_parent().hide_info_menu()			
			return 
			
		# move or attack already but this square has not unit
		if Globals.TAKENACTION and not occupied_by["unit"]:
			get_parent().attacking = false						
			get_parent().show_info_menu(global_position,self)		
			get_parent().clear_available_tiles()			
			get_parent().clear_available_attack_tiles()
			get_parent().hide_select_menu()
			return
		
		#move or attack already but its a different unit
		if Globals.TAKENACTION and Globals.TAKENACTION != occupied_by["unit"]:
			get_parent().attacking = false
			get_parent().show_info_menu(global_position,self)			
			get_parent().clear_available_tiles()			
			get_parent().clear_available_attack_tiles()
			get_parent().hide_select_menu()
			return
		
		#move or attack already but im clicking myself
		if Globals.TAKENACTION and Globals.TAKENACTION == occupied_by["unit"]:
			get_parent().attacking = false			
			get_parent().show_select_menu(global_position,self)
			get_parent().clear_available_tiles()
			get_parent().clear_available_attack_tiles()
			return

###################################### if player has not moved with or used an action ######################################
		#if the plyaer is not attacking and he presses a square with a unit on it, that should be the trigger for the menu
		if occupied_by["unit"] and not get_parent().attacking:
			# disable the action button if unit is disabled
			print("is still disabled")
			if occupied_by["unit"].disabled_turns_left > 0:
				get_parent().disable_action_button()
			get_parent().show_select_menu(global_position,self)
			get_parent().clear_available_tiles()			
			get_parent().clear_available_attack_tiles()
		else:
			#havent aciton yet but want to move
			if available_tile.visible == true: #move action on available tile
				occupied_by["unit"] = get_parent().selected_tile.occupied_by["unit"]
				get_parent().selected_tile.occupied_by["unit"].global_position = global_position
				Globals.TAKENACTION = get_parent().selected_tile.occupied_by["unit"]
				get_parent().selected_tile.occupied_by["unit"] = null
				get_parent().disable_move_button()
			# havent move yet but want to attack
			elif available_attack_tile.visible == true or target_tile.visible == true:
				Globals.TAKENACTION = get_parent().selected_tile.occupied_by["unit"]
				# look for any units on this tilenode, and trigger their get_hit()
				for tile in get_parent().available_attack_tiles:
					if get_parent().all_tiles[tile].occupied_by["unit"]:
						var attack_tile_info = get_parent().available_attack_tiles[tile]
						# attack_tile_info contains a dictionary with various attack details such as damage
						get_parent().all_tiles[tile].occupied_by["unit"].get_hit(attack_tile_info)
				if get_parent().available_attack_tiles[tile_coordinates].has("dash"):
					var dash_destination = get_parent().available_attack_tiles[tile_coordinates]["dash"]["destination"]
					get_parent().selected_tile.occupied_by["unit"].warp_to(dash_destination)
				get_parent().clear_available_attack_tiles()
				get_parent().disable_action_button()
				get_parent().attacking = false
				await Globals.complete_fight_quest(Globals.TAKENACTION)
				
			get_parent().clear_available_tiles()						
			get_parent().clear_available_attack_tiles()
			get_parent().hide_select_menu()
			get_parent().hide_info_menu()			
			
		print("tile at ",tile_coordinates," is clicked")
		print("tile at ",tile_coordinates," has ", occupied_by)

func toggle_available_tile():
	available_tile.visible = !available_tile.visible

func toggle_available_attack_tile():
	available_attack_tile.visible = !available_attack_tile.visible
	
func show_available_attack_tile():
	available_attack_tile.visible = true
	
func hide_available_attack_tile():
	available_attack_tile.visible = false
	
func show_target_tile():
	target_tile.visible = true
	
func hide_target_tile():
	target_tile.visible = false

func is_empty_tile():
	if occupied_by["unit"]:
		return true
		

func add_terrain(terrain_type : String):
	if terrain_type == "marble":
		var new_terrain = load("res://Terrain/Marble.tscn").instantiate()
		add_child(new_terrain)
		move_child(new_terrain, 0)
		occupied_by["terrain"] = new_terrain
		
	if terrain_type == "garden":
		var new_terrain = load("res://Terrain/Garden.tscn").instantiate()
		add_child(new_terrain)
		move_child(new_terrain, 0)		
		occupied_by["terrain"] = new_terrain

	if terrain_type == "throne":
		var new_terrain = load("res://Terrain/Throne.tscn").instantiate()
		add_child(new_terrain)
		move_child(new_terrain, 0)		
		occupied_by["terrain"] = new_terrain

func get_terrain():
	return occupied_by["terrain"]
