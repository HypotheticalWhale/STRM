extends Node

const TILE_SIZE = 32
var round = 1
var score = {
	"P1" : 0,
	"P2" : 0
}
var WHOSTURNISIT = "P1"
var TAKENACTION
var quests : Dictionary = {
	"Fight" : {
		"description" : "get hit or hit something",
		"reward" : 100	#gains 5 xp
	},
	"Traveller": {
		"description" : "get hit or hit something",
		"reward" : 100	#gains 2 xp
	},
	"Hands-off Approach": {
		"description" : "get hit or hit something",
		"reward" : 100	#gains 2 xp
	},
	"Landscaping": {
		"description": "dog",
		"reward": 100
	},
	"You're it": {
		"description": "dog",
		"reward": 100
	},
	"Let me show you to your room":{
		"description": "dog",
		"reward": 100
	},
	"Smelliest guy on earth":{
		"description": "You're so smelly you no longer need a quest",
		"reward": 0
	},
	"Walking Dogs": {
		"description": "Walk a dog in real life win the game!",
		"reward": 0
	},
	"Chariot Boy": {
		"description": "Don't speak to my son",
		"reward": 0
	},
	"I'm a lifelong learner": {
		"description": "You're already maxed out? Why are you still hustling?",
		"reward": 0
	},
	"Keeper of the vault in my heart <3": {
		"description": "Huh? HUH? HUUUHHH? HUUUUUUUUUH????????",
		"reward": 0
	}
}
var skills = {
	"Sweep Attack": {
		"shape": [Vector2(1,0),Vector2(0,1),Vector2(0,-1),Vector2(2,0)],
		"damage multiplier": 0.1,
		"optional effects": {
			"sweet spot": Vector2(1,0)
		},
		"description": "you sweep the floor sweep sweep",
	},
	"Trim Bushes": {
		"shape": [Vector2(1,-1),Vector2(1,1),Vector2(2,0),Vector2(3,-1),Vector2(3,1),Vector2(4,-2),Vector2(4,2)],
		"damage multiplier": 1.1,
		"optional effects": {
			"sweet spot": Vector2(2,0)	# deals double damage at Vector2(1,1)
		}
	},
	"Backstab": {
		"shape": [Vector2(2,0)],
		"damage multiplier": 0.1,
		"optional effects": {
			#"backstab": 1.5	# backstab modifies damage by 1.5X
			"disable": 1,
			"dash": null,
		}
	},
	"Piercing Ray": {
		"shape": [Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(4,0)],
		"damage multiplier": 0.1,
		"optional effects": {
			"knockback": 1,
		}
	},
	"Your weapons, please.": { 
		"shape": [Vector2(1,0), Vector2(2,0)],
		"damage multiplier": 0.1,
		"optional effects": {
			"knockback": 1,	# knocks back 2 squares
			"disable": 1	# disables unit for 1 turn
		}
	},
	"Fleet-footed Kick.": {
		"shape": [Vector2(2,0)],
		"damage multiplier": 0.0,
		"optional effects": {
			"dash": null, # just dashes to the target tile. no other variables
		}
	},
	"Tea Party for Two": {	# displaces two random units to two locations near the butler separated by a tea table
		"shape": [],	# is attacking everyone bro thats why
		"damage multiplier": 0.0,
		"optional effects": {
			"displace": [Vector2(2, -1), Vector2(2, 1)],
			"change terrain": [
				["tea table", [Vector2(2,0)]]
			],
			"immobilize": 1
		}
	},
	"I come with great news": {	# attacks a unit one tile away. if unit is wet, create a cone of bird shit terrain behind unit.
		"shape": [Vector2(1,0)],
		"damage multiplier": 0.1,
		"optional effects": {
			"splatter droppings": null,
		}
	},
	"Cloister Garth Commoner's Clubs": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 0),
			Vector2(3, 0), Vector2(3,-1), Vector2(3, 1),
			Vector2(4, 0),
		],
		"damage multiplier": 0.1,
		"optional effects": {
			"random gardens": null
		}
	},
	"Vineyard Merchant's Diamonds": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 1), Vector2(2, 0), Vector2(2, -1),
			Vector2(3, 1), Vector2(3, 0), Vector2(3, -1),
			Vector2(4, 0)
		],
		"damage multiplier": 0.1,
		"optional effects": {
			"random gardens": null,
			"gain attack": 1,
		}
	},
	"Flowerbed Lover's Hearts": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 1), Vector2(2, 0), Vector2(2, -1),
			Vector2(3, 2), Vector2(3, 1), Vector2(3, 0), Vector2(3, -1), Vector2(3, -2),
			Vector2(4, 1), Vector2(4, -1),
		],
		"damage multiplier": 0.1,
		"optional effects": {
			"random gardens": null,
			"gain attack": 1,
			"gain health": 1,
		}
	},
	"Orchard Elite's Spades": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 1), Vector2(2, 2), Vector2(2, 0), Vector2(2, -1), Vector2(2, -2),
			Vector2(3, 2), Vector2(3, 1), Vector2(3, 0), Vector2(3, -1), Vector2(3, -2),
			Vector2(4, 1), Vector2(4, 0), Vector2(4, -1),
			Vector2(5, 0),
		],
		"damage multiplier": 0.1,
		"optional effects": {
			"random gardens": null,
			"gain attack": 10,
			"gain health": 10,
			"gain movement": 1,
		}
	},
	"Go Fetch!": {
		"shape": [
			Vector2(-2, -2), Vector2(-1, -2), Vector2(0, -2), Vector2(1, -2), Vector2(2, -2),
			Vector2(-2, -1), Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1), Vector2(2, -1),
			Vector2(-2, 0), Vector2(-1, 0), Vector2(1, 0), Vector2(2, 0),
			Vector2(-2, 1), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1),
			Vector2(-2, 2), Vector2(-1, 2), Vector2(0, 2), Vector2(1, 2), Vector2(2, 2)
			],
		"damage multiplier": 0,
		"optional effects": {},
		"description": "bite anyone and keep them on a tight leash"
	},
	"I love gates": {
		"shape": [
			Vector2(0,0)
			],
		"damage multiplier": 0,
		"optional effects": {}
	},
	"My shift is over": {
		"shape": [
			Vector2(1, 0)
		],
		"damage multiplier": 10,
		"optional effects": {
			"yeet self": 7,		# yeets himself into a random tile 7 tiles away
		}
	}
}

var jobs : Dictionary = {
	"Gardener": "res://Jobs/Gardener.tscn", # APQ
	"Butler": "res://Jobs/Butler.tscn", 
	"Dog Walker" : "res://Jobs/DogWalker.tscn",
	"Card Soldier" : "res://Jobs/CardSoldier.tscn",
	"Bell Boy" : "res://Jobs/BellBoy.tscn", # A
	"Messenger": "res://Jobs/Messenger.tscn", # A
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
	"Green Thumbs" : {
		"description": "You deal extra damage on green tiles :-)",
		"damage multiplier": 1.5
	},
	"Die Mond": { #change suit based on tile you are standing on, you neeed more terrain 
		"description": "Change to a stronger suit when you attack on special garden tiles",
		"damage multiplier": 1.0
	},
	"No hooligans alllowed.": { # Disable all enemy units on marble floor 
		"description": "You deal extra damage on green tiles :-)",
		"damage multiplier": 1.0
	},
	"Take a ride.": {
		"description": "You deal extra damage on green tiles :-)",
		"damage multiplier": 1.0
	},
	"Teethed to the arm.": {
		"description": "You deal extra damage on green tiles :-)",
		"damage multiplier": 1.0
	},
	"Fast runner": {
		"description": "You deal extra damage on green tiles :-)",
		"damage multiplier": 1.0
	},
	"Kleptomaniac": {
		"description": "You deal extra damage on green tiles :-)",
		"damage multiplier": 1.0
	},
	"Pigeon Rider": { # bird shit is a one way portal when you hit a wet enemy
		"description": "When you touch an enemy, they become wet",
		"damage multiplier": 1.0
	},
	"Don't touch my stuff": {
		"description": "dont tuch my stf!",
		"damage multiplier": 1.0
	},
	
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
	if get_tree().current_scene.has_node("UI/BottomRightContainer/TileInfo") == false:
		printerr("Not allowed to show tile_info in scene other than Main.tscn.")
		return
	var tile_info = get_tree().current_scene.get_node("UI/BottomRightContainer/TileInfo")
	tile_info.visible = true
	tile_info.update_info(tile.get_terrain().type, tile.get_terrain().defense, tile.get_terrain().movement_penalty)


func show_quest_info(tile: Object):
	var quest_ui_node: Object = get_tree().current_scene.get_node("UI/BottomRightContainer/QuestInfo")
	if tile.occupied_by["unit"] == null:
		quest_ui_node.visible = false
	else:
		var unit: Object = tile.occupied_by["unit"]
		quest_ui_node.visible = true
		quest_ui_node.get_node("VBoxContainer/QuestHeader").text = str(unit.CURRENT_JOB) + "'s Quest"
		quest_ui_node.get_node("VBoxContainer/QuestDescription").text = quests[unit.QUEST]["description"]


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


func complete_unit_quest(unit: Object, quest):
	if unit.QUEST != quest:
		return
	if unit.is_potential_jobs_empty():
		return
	print(unit, " is completing "+quest+ " quest")
		
	unit.xp = unit.xp + quests[quest]["reward"]
	get_tree().current_scene.get_node(unit.UI_EXP_LINK).get_parent().get_child(1).value = unit.xp
	if unit.xp >= unit.max_xp:
		get_tree().current_scene.get_node(unit.UI_EXP_LINK).get_parent().get_child(1).value = 0
		await unit.level_up()
