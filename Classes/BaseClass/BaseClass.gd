extends Node2D
class_name BaseClass

var MAX_HEALTH
var CURRENT_HEALTH
var TEAM
var MOVEMENT
var ACTIONS
var DAMAGE
var CURRENT_JOB
var PASSIVES = []
var UI_EXP_LINK
var QUEST 
var POTENTIAL_JOBS : Array[String]
var enemies_touched = []

# quest specific
var xp : int
var max_xp : int
var num_hits_taken_and_dealt : int

# status ailments
var disabled_turns_left: int = 0
var immobilized_turns_left: int = 0

# Duration for color change
var color_change_duration: float = 0.5
var original_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	await initialize_stats()
	await initialize_sprites()
	original_color = self.modulate

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


func take_damage(damage):
	# Change to red to indicate damage
	change_color(Color.RED)
	CURRENT_HEALTH -= damage
	
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
	if who_is_hitting.QUEST == "You're it": #Messenger Passive
		if who_is_hitting.TEAM == self.TEAM:
			heal(who_is_hitting.DAMAGE)
		else:
			if self not in who_is_hitting.enemies_touched:
				who_is_hitting.enemies_touched.append(self)
				print("Touched: ",who_is_hitting.enemies_touched)
				print("Touched length", len(who_is_hitting.enemies_touched))
			get_hit({"damage":DAMAGE},who_is_hitting)
			
func get_hit(attack_info: Dictionary):
	# attack_info example = {
	#	"who is hitting": Object1234,
	#	"damage": 10,
	#	"knockback": {"direction": Vector2(1,0), "distance": 2},
	#	"disable": 2, (disable duration)
	# 	"displace": null
	#}
	
	# damage
	CURRENT_HEALTH -= attack_info["damage"]
	var who_is_hitting = attack_info["who is hitting"]
	if who_is_hitting.PASSIVES.has("Green Thumbs") and get_tree().current_scene.all_tiles[global_position].occupied_by["terrain"].type == "Garden": #Gardener Quest
		Globals.complete_unit_quest(who_is_hitting,"Landscaping")
	if CURRENT_HEALTH <= 0:
		print("im ded")
		get_tree().current_scene.all_tiles[global_position].occupied_by["unit"] = null
		for unit in PlayerData.player1_units:
			if PlayerData.player1_units[unit] == self:
				PlayerData.player1_units.erase(unit)
		for unit in PlayerData.player2_units:
			if PlayerData.player2_units[unit] == self:
				PlayerData.player2_units.erase(unit)
		self.queue_free()
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
	
	
		
func add_job(job_name : String):
	var job_node = load(Globals.jobs[job_name]).instantiate()
	$Jobs.add_child(job_node)
	ACTIONS.append(job_node.skill)
	MAX_HEALTH += job_node.MAX_HEALTH
	CURRENT_HEALTH = MAX_HEALTH
	MOVEMENT = job_node.MOVEMENT
	DAMAGE += job_node.DAMAGE
	QUEST = job_node.QUEST
	CURRENT_JOB = job_name
	PASSIVES.append(job_node.passive)
	await update_sprite()

func warp_to(destination_vector: Vector2):
	get_tree().current_scene.all_tiles[global_position].occupied_by["unit"] = null
	global_position = destination_vector
	get_tree().current_scene.all_tiles[global_position].occupied_by["unit"] = self

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
