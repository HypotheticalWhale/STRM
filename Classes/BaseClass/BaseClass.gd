extends Node2D
class_name BaseClass

var MAX_HEALTH
var CURRENT_HEALTH
var TEAM
var MOVEMENT
var ACTIONS
var QUEST : String

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
	xp = 0
	max_xp = 100
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


func attack():
	if QUEST == "fight":
		xp += Globals.get_quest_xp(QUEST)
		await level_up_if_possible()
		

func level_up_if_possible():
	if xp < max_xp:
		return	# not possible to level yet
	if xp >= max_xp:
		xp = xp - max_xp
		#AnimationPlayer.play("level_up")
		var lvl_ui = get_tree().current_scene.get_node("UI/LevelUp")
		get_tree().paused = true
		lvl_ui.visible = true
		

