extends Node2D
class_name BaseClass

var MAX_HEALTH
var CURRENT_HEALTH
var TEAM

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
