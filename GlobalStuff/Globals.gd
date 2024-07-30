extends Node

const TILE_SIZE = 32
var WHOSTURNISIT = "P1"
var TAKENACTION
var quests : Dictionary = {
	"fight" : {
		"description" : "get hit or hit something",
		"reward" : 50	#gains 50 xp
	}
}
var skills = {
	"Sweep Attack": [Vector2(1,0),Vector2(0,1),Vector2(0,-1)],
	"Trim Bushes": [Vector2(1,0),Vector2(0,1),Vector2(0,-1)],
	"Backstab": [Vector2(1,0)],
	"Piercing Ray":[Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(4,0)]
}

var jobs : Dictionary = {
	"gardener" : "res://Jobs/Gardener.tscn",
	"butler" : "res://Jobs/Butler.tscn",
	"chef" : "res://Jobs/Chef.tscn",
	"lawnsguard" : "res://Jobs/Lawnsguard.tscn",
	"dog_handler" : "res://Jobs/DogHandler.tscn",
	"card_solider" : "res://Jobs/CardSoldier.tscn"
}

var passives : Dictionary = {
	"Green Thumbs" : "Gives nonsense, please replace this with actual passive"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func toggle_player_turn():
	if WHOSTURNISIT == "P2":
		WHOSTURNISIT = "P1"
	else:
		WHOSTURNISIT = "P2"
	return


func show_tile_info(tile : Object):
	if get_tree().current_scene.has_node("UI/TileInfo") == false:
		printerr("Not allowed to show tile_info in scene other than Main.tscn.")
		return
	var tile_info = get_tree().current_scene.get_node("UI/TileInfo")
	tile_info.visible = true
	tile_info.update_info(tile.get_terrain().type, tile.get_terrain().defense, tile.get_terrain().movement_penalty)


func get_quest_xp(completed_quest : String):
	return quests[completed_quest]["reward"]

func rotate_skill_to_direction(direction,skill_name):
	var new_skill_coords = []
	var coord
	if direction == "E":
		return skills[skill_name]
	if direction == "W":
		for skill in skills[skill_name]:
			new_skill_coords.append(skill*-1)
		return new_skill_coords
	if direction == "N":
		for skill in skills[skill_name]:
			new_skill_coords.append(Vector2(skill[1],skill[0]*-1))
		return new_skill_coords	
	if direction == "S":
		for skill in skills[skill_name]:
			new_skill_coords.append(Vector2(skill[1],skill[0]))
		return new_skill_coords
		
