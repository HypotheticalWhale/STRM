extends Node2D
class_name BaseClass

var MAX_HEALTH
var CURRENT_HEALTH
var TEAM
var MOVEMENT
var CURRENT_MOVEMENT
var ACTIONS
var DAMAGE
var BASE_DAMAGE
var CURRENT_JOB
var PASSIVES = []
var UI_EXP_LINK
var QUEST 
var POTENTIAL_JOBS : Array[String]
var enemies_touched = []
var leashed_units = []
var wanted = 0	# for vaultskeeper
var my_vault: Object = null
var suit: String = ""
var description = "Just the base servant, he lives in the manor"
var skill = "Sweep Attack"
var passive = "Noob"
# quest specific
var xp : int
var max_xp : int
var num_hits_taken_and_dealt : int

# status ailments
var disabled_turns_left: int = 0
var immobilized_turns_left: int = 0
var wet_turns_left: int = 0

# Duration for color change
var color_change_duration: float = 0.5
var original_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	await initialize_stats()
	await initialize_sprites()
	original_color = self.modulate

func _process(delta):
	if "Kleptomaniac" in PASSIVES and len(enemies_touched) > 0: #Bellboy QUEST
		var damage_multiplier = 1 + len(enemies_touched)*0.1
		DAMAGE = BASE_DAMAGE * damage_multiplier
			
func initialize_sprites():
	pass
	
func initialize_stats():
	pass

func set_sprite_blue():
	if $RedSprite.visible == true:
		$RedSprite.visible = false
	if $BlueSprite.visible != true:
		$BlueSprite.visible = true
		
func set_sprite_red():
	if $RedSprite.visible != true:
		$RedSprite.visible = true
	if $BlueSprite.visible == true:
		$BlueSprite.visible = false


func is_potential_jobs_empty():
	if len($Jobs.get_children()) > 0 and len($Jobs.get_children()[-1].potential_jobs) == 0:	# if unit is at max job tier, do nothing
		return true
	return false
		

func level_up():
	xp = xp - max_xp
	var lvl_ui = get_tree().current_scene.get_node("UI/LevelUp")
	lvl_ui.unit_to_level = self
	get_tree().paused = true
	lvl_ui.visible = true
	
	if len($Jobs.get_children()) == 0:	# if unit has no jobs yet
		lvl_ui.update_jobs(POTENTIAL_JOBS)
	else:	# if unit has a job, take the most recent one
		lvl_ui.update_jobs($Jobs.get_children()[-1].potential_jobs)


func DIDIWIN():
	var tile_node = get_tile_node()
	if tile_node.is_manor and tile_node.occupied_by["terrain"].WHOSTHRONEISIT != TEAM:
		get_tree().current_scene.get_node("UI/EndRoundButton").visible = true
		get_tree().current_scene.get_node("UI/EndRoundButton").text = TEAM + ", YOU WIN!!"
		Globals.WHOSTURNISIT = "P1"
		get_tree().paused = true


func take_damage(damage):
	# Change to red to indicate damage
	change_color(Color.RED)
	CURRENT_HEALTH -= damage
	print("Took ", damage, "Damage")
	print("Taking Damage Current Health/Max Health: ",CURRENT_HEALTH,"/",MAX_HEALTH)
	
func heal(heal_amount):
	# Change to green to indicate healing
	change_color(Color.GREEN)
	if CURRENT_HEALTH >= MAX_HEALTH:
		CURRENT_HEALTH = MAX_HEALTH
	print("Healing Current Health/Max Health: ",CURRENT_HEALTH,"/",MAX_HEALTH)
	

func change_color(new_color: Color):
	# Set the new color and start a timer to reset it
	self.modulate = new_color
	await get_tree().create_timer(color_change_duration).timeout
	self.modulate = original_color

func next_to_messenger(who_is_hitting):
	# messenger passive
	if who_is_hitting.TEAM == self.TEAM:
		heal(who_is_hitting.DAMAGE)
	else:
		if self not in who_is_hitting.enemies_touched:
			who_is_hitting.enemies_touched.append(self)
			print("Touched: ",who_is_hitting.enemies_touched)
			print("Touched length", len(who_is_hitting.enemies_touched))
			if len(who_is_hitting.enemies_touched) == 3:
				Globals.complete_unit_quest(who_is_hitting,"You're it")
		get_hit({
			"skill name": "Here's a gift",
			"damage":DAMAGE,
			"who is hitting": who_is_hitting})


func next_to_pigeon_commander(who_is_hitting):
	# pigeon commander passive
	show_wet_status(true)
	wet_turns_left = 2

			
func get_hit(attack_info: Dictionary):
	# attack_info example = {
	#	"who is hitting": Object1234,
	#	"damage": 10,
	#	"knockback": {"direction": Vector2(1,0), "distance": 2},
	#	"disable": 2, (disable duration)
	# 	"displace": null
	#}

	var who_is_hitting = attack_info["who is hitting"]
	
	if who_is_hitting == self and who_is_hitting.TEAM == "P1" and attack_info["skill name"] == "I love gates": #Charioteer skill
		print("list of rightmost cells", get_parent().get_three_rightmost_tiles())
	elif who_is_hitting == self and who_is_hitting.TEAM == "P2" and attack_info["skill name"] == "I love gates":
		print("list of leftmost cells", get_parent().get_three_leftmost_tiles())
	elif who_is_hitting.TEAM == self.TEAM and who_is_hitting.CURRENT_JOB == "Charioteer":
		var team_gate_locations = get_parent().get_team_gates(who_is_hitting.TEAM )
		var gate_location = team_gate_locations[randi() % len(team_gate_locations)]
		self.get_tile_node().occupied_by["unit"] == null
		self.global_position = gate_location.global_position
		gate_location.occupied_by["unit"] = self
		
	if attack_info["skill name"] == "Your weapons, please." and self not in who_is_hitting.enemies_touched:
		who_is_hitting.enemies_touched.append(self)
	if who_is_hitting.PASSIVES.has("Teethed to the arm."): #Dog walker passive
		who_is_hitting.leashed_units.append(self)
		
	if who_is_hitting.PASSIVES.has("Green Thumbs") and get_tree().current_scene.all_tiles[global_position].occupied_by["terrain"].type == "Garden": #Gardener Quest
		Globals.complete_unit_quest(who_is_hitting,"Landscaping")
	# knockback
	if attack_info.has("knockback"):
		var destination_coords: Vector2 = global_position
		var direction: String = attack_info["knockback"]["direction"]
		var distance: int = attack_info["knockback"]["distance"]
		var step_vector: Vector2
		
		if direction == "E":
			step_vector = Vector2(1,0) * Globals.TILE_SIZE
		if direction == "N":
			step_vector = Vector2(0,-1) * Globals.TILE_SIZE
		if direction == "W":
			step_vector = Vector2(-1,0) * Globals.TILE_SIZE
		if direction == "S":
			step_vector = Vector2(0,1) * Globals.TILE_SIZE
	
		for i in range(distance):
			var new_destination_coords: Vector2 = destination_coords + step_vector
			if new_destination_coords not in get_tree().current_scene.valid_tiles:
				break
			if get_tree().current_scene.all_tiles[new_destination_coords].occupied_by["unit"] != null:
				break
			destination_coords = new_destination_coords
		
		await warp_to(destination_coords)
		await get_tile_node().resolve_droppings_entry_check()

	# disable
	if attack_info.has("disable"):
		disabled_turns_left = attack_info["disable"]
		# give it a disabled counter for each disable_duration
		# at the start of owners turn, if disabled counter > 0, disable its attack button
		# at the end of the owners turn, decrement it.

	# immobilize
	if attack_info.has("immobilize"):
		immobilized_turns_left = attack_info["immobilize"]
		# same logic as disable
	
	if attack_info.has("displace"):
		var destination = get_tree().current_scene.displace_destination_coords.pop_front() * Globals.TILE_SIZE
		await warp_to(destination)
		await get_tile_node().resolve_droppings_entry_check()
		
	if attack_info.has("splatter droppings"):
		var direction = (global_position - attack_info["who is hitting"].global_position).normalized()
		var num_affected_tiles = 5
		var origin_tile_coord = global_position/Globals.TILE_SIZE
		var affected_tile_coords = []
		for step in range(num_affected_tiles):
			var affected_tile_coord = origin_tile_coord + (direction * (step+1))
			affected_tile_coords.push_front(affected_tile_coord)	# so that the furthest tile would be at the front of the array

		var has_created_droppings_exit = false
		var i = 0
		var final_affected_tile_grid_pos = {
			"entry": null,
			"path": [],
			"exit": null,
		}
		for coord in affected_tile_coords:
			var grid_pos = coord * Globals.TILE_SIZE
			if i == (num_affected_tiles - 1) and has_created_droppings_exit == false:
				final_affected_tile_grid_pos = {}
				# if the entrance has to be the exit
				break
			if grid_pos not in get_tree().current_scene.valid_tiles:
				i += 1
				continue
			if has_created_droppings_exit == false and get_tree().current_scene.all_tiles[grid_pos].get_terrain().type == "Throne":
				# if trying to create exit on throne tile
				i += 1
				continue
			if has_created_droppings_exit == false and get_tree().current_scene.all_tiles[grid_pos].get_terrain().type != "Throne":
				# valid tile for exit
				final_affected_tile_grid_pos["exit"] = grid_pos
				has_created_droppings_exit = true
				i += 1
				continue
			if get_tree().current_scene.all_tiles[grid_pos].get_terrain().type == "Throne":
				# if any part of the path or entry has the throne on it, the whole path breaks
				final_affected_tile_grid_pos = {}
				break
			if i == (num_affected_tiles - 1) and has_created_droppings_exit == true:
				final_affected_tile_grid_pos["entry"] = grid_pos
				i += 1
				continue
			if has_created_droppings_exit:
				final_affected_tile_grid_pos["path"].append(grid_pos)
				i += 1
				continue
		if len(final_affected_tile_grid_pos) != 0:
			# if the creation of the path was not interrrupted by throne terrain
			var droppings_exit_tile = get_tree().current_scene.all_tiles[final_affected_tile_grid_pos["exit"]]
			var droppings_entry_tile = get_tree().current_scene.all_tiles[final_affected_tile_grid_pos["entry"]]
			droppings_exit_tile.add_terrain("droppings exit")
			for grid_pos in final_affected_tile_grid_pos["path"]:
				get_tree().current_scene.all_tiles[grid_pos].add_terrain("droppings path")
			droppings_entry_tile.add_terrain("droppings entry")
			# keep a reference to the exit on the entrance
			droppings_entry_tile.occupied_by["terrain"].droppings_exit_terrain = droppings_exit_tile.occupied_by["terrain"]

	if attack_info.has("random gardens"):
		await who_is_hitting.suit_up()

	if attack_info.has("gain attack"):
		who_is_hitting.BASE_DAMAGE += attack_info["gain attack"]
				
	if attack_info.has("gain health"):
		who_is_hitting.MAX_HEALTH += attack_info["gain health"]
		who_is_hitting.CURRENT_HEALTH += attack_info["gain health"]

	if attack_info.has("gain movement"):
		who_is_hitting.MOVEMENT += attack_info["gain movement"]
		
	print("attack_info: ", attack_info)
	if attack_info.has("yeet self"):
		who_is_hitting.yeet_self(attack_info["yeet self"])		# if the attack hits a unit, the owner yeets himself to a random tile {yeet self} units away

	# damage
	if attack_info["damage"] > 0:
		take_damage(attack_info["damage"])
	elif attack_info["damage"] < 0:
		heal(attack_info["damage"])
	else:
		pass
	if CURRENT_HEALTH <= 0:
		print("im ded")
		CURRENT_HEALTH = MAX_HEALTH
		get_tree().current_scene.all_tiles[global_position].occupied_by["unit"] = null
		self.global_position = Vector2(0,-999999)
		return

func add_job(job_name : String):
	var job_node = load(Globals.jobs[job_name]).instantiate()
	$Jobs.add_child(job_node)
	ACTIONS.append(job_node.skill)
	MAX_HEALTH += job_node.MAX_HEALTH
	CURRENT_HEALTH = MAX_HEALTH
	MOVEMENT = job_node.MOVEMENT
	DAMAGE += job_node.DAMAGE
	BASE_DAMAGE = DAMAGE
	QUEST = job_node.QUEST
	CURRENT_JOB = job_name
	PASSIVES.append(job_node.passive)
	await update_sprite()
	
	# card solider specific
	if job_name == "Card Soldier":
		suit = "Clubs"
		randomize()
		var random_coord_x = randi_range(3, get_tree().current_scene.GRID_SIZE[0]-2) * Globals.TILE_SIZE
		var random_coord_y = randi_range(3, get_tree().current_scene.GRID_SIZE[1]-2) * Globals.TILE_SIZE
		for step_x in [-1 * Globals.TILE_SIZE, 0 * Globals.TILE_SIZE, 1 * Globals.TILE_SIZE]:
			for step_y in [-1 * Globals.TILE_SIZE, 0 * Globals.TILE_SIZE, 1 * Globals.TILE_SIZE]:
				get_tree().current_scene.all_tiles[Vector2(random_coord_x + step_x, random_coord_y + step_y)].add_terrain("Cloister Garth")
		return
	
	# vaultskeeper specific
	if job_name == "Vaults Keeper":
		var potential_destination_coords = []
		var unit_coord = global_position/Globals.TILE_SIZE
		var max_distance_from_vault = 3
		for step_x in range(-max_distance_from_vault, max_distance_from_vault + 1):
			for step_y in range(-max_distance_from_vault, max_distance_from_vault + 1):
				var new_pos = Vector2(unit_coord.x + step_x, unit_coord.y + step_y) * Globals.TILE_SIZE
				if new_pos not in get_tree().current_scene.valid_tiles:
					continue
				if get_tree().current_scene.all_tiles[new_pos].occupied_by["terrain"].type == "throne":
					continue
				potential_destination_coords.append(new_pos)
		randomize()
		potential_destination_coords.shuffle()
		var vault_destination_pos = potential_destination_coords[0]	# first pos in the shuffled list
		if TEAM == "P1":
			await get_tree().current_scene.all_tiles[vault_destination_pos].add_terrain("Vault Blue")
		if TEAM == "P2":
			await get_tree().current_scene.all_tiles[vault_destination_pos].add_terrain("Vault Red")
		var new_vault = get_tree().current_scene.all_tiles[vault_destination_pos].get_terrain()
		assert(new_vault.type == "Vault Red" or new_vault.type == "Vault Blue") # the terrain on the vaultskeeper should be a vault at this point
		new_vault.vault_owner = self
		my_vault = new_vault
		return


func warp_to(destination_vector: Vector2):
	get_tree().current_scene.all_tiles[global_position].occupied_by["unit"] = null
	global_position = destination_vector
	get_tree().current_scene.all_tiles[global_position].occupied_by["unit"] = self
	await DIDIWIN()


func get_tile_node():
	var unit_coord = global_position/Globals.TILE_SIZE
	var tile_node = null
	for pos in get_tree().current_scene.all_tiles:
		var coord = pos / Globals.TILE_SIZE
		if coord == unit_coord:
			tile_node = get_tree().current_scene.all_tiles[pos]
			return tile_node
	
	# unit should always be able to get its tile node
	assert(tile_node != null) 
	return tile_node


func update_sprite():
	if $Jobs.get_child_count() == 0:	# Only has baseclass
		if TEAM == "P1":
			set_sprite_blue()
		if TEAM == "P2":
			set_sprite_red()
	
	if $Jobs.get_child_count() > 0:		# Has additional jobs
		var newest_job = $Jobs.get_children()[-1]
		$RedSprite.texture = newest_job.get_node("Red").texture
		$BlueSprite.texture = newest_job.get_node("Blue").texture
		if TEAM == "P1":
			set_sprite_blue()
		if TEAM == "P2":
			set_sprite_red()


func show_wet_status(should_i_show: bool):
	if should_i_show == true:
		$RedSprite.material = load("res://Shaders/WetShaderMaterial.tres")
		$BlueSprite.material = load("res://Shaders/WetShaderMaterial.tres")
	else:
		$RedSprite.material = null
		$BlueSprite.material = null


func suit_up():
	assert(suit != null)	# only units with a suit can call this function
	var terrain_condition_for_suit_up: String
	var new_garden_type: String
	match suit:
		"Clubs":
			new_garden_type = "Vineyard"
			terrain_condition_for_suit_up = "Cloister Garth"
		"Diamonds":
			new_garden_type = "Flowerbed"
			terrain_condition_for_suit_up = "Vineyard"
		"Hearts":
			new_garden_type = "Orchard"
			terrain_condition_for_suit_up = "Flowerbed"
		"Spades":
			new_garden_type = ""
			terrain_condition_for_suit_up = "Orchard"

	if get_tile_node().get_terrain().type != terrain_condition_for_suit_up and terrain_condition_for_suit_up != "":
		# if the tile the aggressor is standing on does not meet the terrain condition AND
		# if the terrain condition isnt an empty string
		return
		
	match suit:
		"Clubs":
			suit = "Diamonds"
			ACTIONS.erase("Cloister Garth Commoner's Clubs")
			ACTIONS.append("Vineyard Merchant's Diamonds")
		"Diamonds":
			suit = "Hearts"
			ACTIONS.erase("Vineyard Merchant's Diamonds")
			ACTIONS.append("Flowerbed Lover's Hearts")
		"Hearts":
			suit = "Spades"
			ACTIONS.erase("Flowerbed Lover's Hearts")
			ACTIONS.append("Orchard Elite's Spades")
		"Spades":
			suit = "Spades"
		
	randomize()
	var x = randi_range(3, get_tree().current_scene.GRID_SIZE[0]-2)
	randomize()
	var y = randi_range(3, get_tree().current_scene.GRID_SIZE[1]-2)
	var garden_origin_coord = Vector2(x, y)
	for i in range(3):
		for j in range(3):
			get_tree().current_scene.all_tiles[Vector2(garden_origin_coord.x+i-1, garden_origin_coord.y+j-1) * Globals.TILE_SIZE].add_terrain(new_garden_type)


func yeet_self(distance: int):
	# get all tiles {distance} tiles away:
	var main_astar = get_tree().current_scene.astar
	var main_all_tiles = get_tree().current_scene.all_tiles
	var potential_tiles = []
	for tile_coords in get_tree().current_scene.valid_tiles:
		if main_all_tiles[tile_coords].occupied_by["terrain"].type == "Throne":
			continue
		if main_all_tiles[tile_coords].occupied_by["unit"] != null:
			continue
		
		if len(main_astar.get_id_path(global_position/Globals.TILE_SIZE,tile_coords/Globals.TILE_SIZE)) == distance:
			potential_tiles.append(tile_coords)
	
	randomize()
	potential_tiles.shuffle()
	await warp_to(potential_tiles[0])
	await get_tile_node().resolve_droppings_entry_check()
	
