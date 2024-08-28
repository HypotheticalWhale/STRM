extends Node2D
class_name BaseClass

var MAX_HEALTH
var CURRENT_HEALTH
var TEAM
var MOVEMENT
var ACTIONS
var DAMAGE
var CURRENT_JOB
var UI_EXP_LINK
var QUEST : String
var POTENTIAL_JOBS : Array[String]

# quest specific
var xp : int
var max_xp : int
var num_hits_taken_and_dealt : int

# Called when the node enters the scene tree for the first time.
func _ready():
	await initialize_stats()
	await initialize_sprites()

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
	
	
func attack():
	if QUEST == "fight":
		if is_potential_jobs_empty():
			return
		xp = xp + Globals.get_quest_xp(QUEST)
		get_parent().get_node(UI_EXP_LINK).get_parent().get_child(1).value = xp
		await level_up_if_possible()
		

func level_up_if_possible():
	if xp < max_xp:
		return	# not possible to level yet
	if xp >= max_xp:
		print("xp crossed")
		xp = xp - max_xp
		var lvl_ui = get_tree().current_scene.get_node("UI/LevelUp")
		lvl_ui.unit_to_level = self
		get_tree().paused = true
		lvl_ui.visible = true
		
		if len($Jobs.get_children()) == 0:	# if unit has no jobs yet
			lvl_ui.update_jobs(POTENTIAL_JOBS)
		else:	# if unit has a job, take the most recent one
			lvl_ui.update_jobs($Jobs.get_children()[-1].potential_jobs)


func get_hit(damage):
	CURRENT_HEALTH -= damage
	if CURRENT_HEALTH <= 0:
		print("im ded")
		self.queue_free()
	print("I get hit for: ", damage)
	print("Current Health/Max Health: ",CURRENT_HEALTH,"/",MAX_HEALTH)


func add_job(job_name : String):
	var job_node = load(Globals.jobs[job_name]).instantiate()
	$Jobs.add_child(job_node)
	ACTIONS.append(job_node.skill)
	MAX_HEALTH += job_node.MAX_HEALTH
	CURRENT_HEALTH = MAX_HEALTH
	MOVEMENT = job_node.MOVEMENT
	DAMAGE += job_node.DAMAGE
	
	await update_sprite()


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
