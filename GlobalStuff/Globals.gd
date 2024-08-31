extends Node

const TILE_SIZE = 32
var WHOSTURNISIT = "P1"
var TAKENACTION
var quests : Dictionary = {
	"fight" : {
		"description" : "get hit or hit something",
		"reward" : 100	#gains 50 xp
	}
}
var skills = {
	"Sweep Attack": {
		"shape": [Vector2(1,0),Vector2(0,1),Vector2(0,-1)],
		"damage multiplier": 0.1,
		"optional effects": {
			"knockback": 3
		}
	},
	"Trim Bushes": {
		"shape": [Vector2(1,-1),Vector2(1,1),Vector2(2,0),Vector2(3,-1),Vector2(3,1),Vector2(4,-2),Vector2(4,2)],
		"damage multiplier": 1.1,
		"optional effects": {
			"sweet spot": Vector2(1,1)	# deals double damage at Vector2(1,1)
		}
	},
	"Backstab": {
		"shape": [Vector2(1,0)],
		"damage multiplier": 0.1,
		"optional effects": {
			#"backstab": 1.5	# backstab modifies damage by 1.5X
			"disable": 1
		}
	},
	"Piercing Ray": {
		"shape": [Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(4,0)],
		"damage multiplier": 1.0,
		"optional effects": {}
	},
	"Your weapons, please.": {
		"shape": [Vector2(1,0), Vector2(2,0)],
		"damage multiplier": 0.1,
		"optional effects": {
			"knockback": 2,	# knocks back 2 squares
			"disable": 1	# disables unit for 1 turn
		}
	}
}

var jobs : Dictionary = {
	"Gardener": "res://Jobs/Gardener.tscn",
	"Butler": "res://Jobs/Butler.tscn",
	"Dog Walker" : "res://Jobs/DogWalker.tscn",
	"Card Soldier" : "res://Jobs/CardSoldier.tscn",
	"Bell Boy" : "res://Jobs/BellBoy.tscn",
	"Messenger": "res://Jobs/Messenger.tscn",
	"Charioteer": "res://Jobs/Charioteer.tscn",
	"Pigeon Commander": "res://Jobs/PigeonCommander.tscn",
	"Vaults Keeper": "res://Jobs/VaultsKeeper.tscn",
	# servants
	#poltergeist - prankster, used to be a resident
	#stonecarver - carves statues
	#vaultsguard - guards the safe. very important dude
	#messenger - sends mail by horse
	#pigeon courier - sends messages with pigeons
	
	
	# nobles
	#vampire child - hes a noble because he uhh is cool
	#flute boy - could be a girl
	#
	
	# entertainers
	#beastmaster - takes care of the animals in collection
	#alcohol man - makes alcohol for the residents
	#baby juggler - 
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

func rotate_coords_to_direction(direction: String,skill_shape: Array):
	var new_skill_coords = []
	var coord
	if direction == "E":
		return skill_shape
	if direction == "W":
		for skill in skill_shape:
			new_skill_coords.append(skill*-1)
		return new_skill_coords
	if direction == "N":
		for skill in skill_shape:
			new_skill_coords.append(Vector2(skill[1],skill[0]*-1))
		return new_skill_coords	
	if direction == "S":
		for skill in skill_shape:
			new_skill_coords.append(Vector2(skill[1],skill[0]))
		return new_skill_coords


func complete_fight_quest(unit: Object):
	print(unit, " is completing fight quest")
	if unit.QUEST != "fight":
		return
	if unit.is_potential_jobs_empty():
		return
		
	unit.xp = unit.xp + quests["fight"]["reward"]
	get_tree().current_scene.get_node(unit.UI_EXP_LINK).get_parent().get_child(1).value = unit.xp
	if unit.xp >= unit.max_xp:
		await unit.level_up()
