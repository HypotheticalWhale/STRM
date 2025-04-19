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
		"description" : "Hit something",
		"reward" : 34	#gains 5 xp
	},
	"Traveller": {
		"description" : "entertainers quest",
		"reward" : 100	#gains 2 xp
	},
	"Hands-off Approach": {
		"description" : "nobles quest",
		"reward" : 100	#gains 2 xp
	},
	"Landscaping": {
		"description": "Stand on a garden tile and hit something",
		"reward": 50 
	},
	"You're it": {
		"description": "Stand adjacent to each enemy unit",
		"reward": 100
	},
	"Let me show you to your room":{
		"description": "Stand on a lobby tile",
		"reward": 25
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
		"description": "Win a game of UNO in real life to win a car",
		"reward": 0
	},
	"The Chandelier Canopy Conundrum": {
		"description": "Hmmm...chandeliers...canopies..",
		"reward": 0
	},
	"Keeper of the vault in my heart <3": {
		"description": "My boss is very powerful. He makes me work/time",
		"reward": 0
	}
}
var skills = {
	"Sweep Attack": {
		"shape": [Vector2(1,0),Vector2(0,1),Vector2(0,-1),Vector2(2,0)],
		"damage multiplier": 1,
		"optional effects": {
			"sweet spot": Vector2(2,0)
		},
		"description": "you sweep the floor sweep sweep",
		"detailed info": "Deals medium damage in a T shape\nDeals double damage at the tip"
	},
	"Trim Bushes": {
		"shape": [Vector2(1,-1),Vector2(1,1),Vector2(2,0),Vector2(3,-1),Vector2(3,1),Vector2(4,-2),Vector2(4,2),Vector2(5,3)],
		"damage multiplier": 2,
		"optional effects": {
			"sweet spot": Vector2(5,3)	# deals double damage at Vector2(1,1)
		},
		"description": "Large scissors for cutting large objects",
		"detailed info": "Deals high damage in a scissor shape\nDeals double damage at the tips"
	},
	# not legacy code bro
	"Backstab": {
		"shape": [Vector2(1,0)],
		"damage multiplier": 2,
		"optional effects": {
			#"backstab": 1.5	# backstab modifies damage by 1.5X
			#"disable": 1,
		},
		"description": "Doesn't actually do more damage from behind",
		"detailed info": "Deals high damage"
	},
	"Piercing Ray": {
		"shape": [Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(4,0)],
		"damage multiplier": 1,
		"optional effects": { 
			"sweet spot": Vector2(4,0),
		},
		"description": "Bad breath travels a long distance sometimes",
		"detailed info": "Deals medium damage in a line"
	},
	"Your weapons please": { 
		"shape": [Vector2(1,0), Vector2(2,0)],
		"damage multiplier": 0.001,
		"optional effects": {
			"disable": 2	# disables unit for 1 turn
		},
		"description": "The bell boy's cart is the second most dangerous thing in this mansion",
		"detailed info": "Disables units in a line"
	},
	"Fleet footed kick": {
		"shape": [Vector2(2,0),Vector2(2,1),Vector2(2,-1),Vector2(3,0),Vector2(3,1),Vector2(3,-1)],
		"damage multiplier": 1.5,
		"optional effects": {
			"dash": null, # just dashes to the target tile. no other variables
		},
		"description": "Mastered the flying kick by binge-watching Jackie Chan films",
		"detailed info": "Deals medium damage to a target within 3 tiles"
	},
	"Tea Party for Two": {	# displaces two random units to two locations near the butler separated by a tea table
		"shape": [],	# is attacking everyone bro thats why
		"damage multiplier": 0.0,
		"optional effects": {
			"displace": [Vector2(2, -1), Vector2(2, 1)],
			"change terrain": [
				["tea table", [Vector2(2,0)]]
			],
			"immobilize": 1,
			"disable": 1
		},
		"description": "Have some tea, and don't get up from your seat for awhile",
		"detailed info": "Warps 2 random units\nImmobilizes and disables them for 1 turn"
	},
	"I come with great news": {	# attacks a unit one tile away. if unit is wet, create a cone of bird shit terrain behind unit.
		"shape": [Vector2(1,0)],
		"damage multiplier": 1,
		"optional effects": {
			"splatter droppings": null,
		},
		"description": "Pigeon droppings make the floor very slippery",
		"detailed info": "Deals medium damage\nMakes the target wet for 2 turns\nCreates a slippery trail behind the target"
	},
	"Cloister Garth Commoner's Clubs": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 0),
			Vector2(3, 0), Vector2(3,-1), Vector2(3, 1),
			Vector2(4, 0),
		],
		"damage multiplier": 1,
		"optional effects": {
			"random gardens": null
		},
		"description": "The first of the 4 card attacks.",
		"detailed info": "Deals medium damage\nThis skill changes when used on a Cloister Garth"
	},
	"Vineyard Merchant's Diamonds": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 1), Vector2(2, 0), Vector2(2, -1),
			Vector2(3, 1), Vector2(3, 0), Vector2(3, -1),
			Vector2(4, 0)
		],
		"damage multiplier": 1,
		"optional effects": {
			"random gardens": null,
			"gain attack": 20,
		},
		"description": "Become stronger. Attack evolves if done on a Vineyard",
		"detailed info": "Deals medium damage\nThis unit gains attack permanently\nThis skill changes when used on a Vineyard"
	},
	"Flowerbed Lover's Hearts": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 1), Vector2(2, 0), Vector2(2, -1),
			Vector2(3, 2), Vector2(3, 1), Vector2(3, 0), Vector2(3, -1), Vector2(3, -2),
			Vector2(4, 1), Vector2(4, -1),
		],
		"damage multiplier": 1,
		"optional effects": {
			"random gardens": null,
			"gain attack": 20,
			"gain health": 100,
		},
		"description": "Become healthier. Attack evolves if done on a Flowerbed",
		"detailed info": "Deals medium damage\nThis unit gains attack and health permanently\nThis skill changes when used on a Flowerbed"
	},
	"Orchard Elite's Spades": {
		"shape": [
			Vector2(1, 0),
			Vector2(2, 1), Vector2(2, 2), Vector2(2, 0), Vector2(2, -1), Vector2(2, -2),
			Vector2(3, 2), Vector2(3, 1), Vector2(3, 0), Vector2(3, -1), Vector2(3, -2),
			Vector2(4, 1), Vector2(4, 0), Vector2(4, -1),
			Vector2(5, 0),
		],
		"damage multiplier": 1,
		"optional effects": {
			"random gardens": null,
			"gain attack": 10,
			"gain health": 10,
			"gain movement": 1,
		},
		"description": "Become more agile. The last of the 4 card attacks.",
		"detailed info": "Deals medium damage\nThis unit gains attack, health and movement permanently\nThis skill changes when used on an Orchard"
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
		"description": "Bite anyone and keep them on a tight leash",
		"detailed info": "Bites nearby units"
	},
	"I love gates": {
		"shape": [
			Vector2(0,0)
			],
		"damage multiplier": 0,
		"optional effects": {},
		"description": "Create some gates"
	},
	"My shift is over": {
		"shape": [
			Vector2(1, 0)
		],
		"damage multiplier": 10,
		"optional effects": {
			"yeet self": 7,		# yeets himself into a random tile 7 tiles away
		},
		"description": "Use as a last resort",
		"detailed info": "Deals massive damage\nWarps the user to a random tile 7 tiles away"
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
	"No hooligans allowed.": { # Disable all enemy units on marble floor 
		"description": "All disable and immobilize effects on Marble tiles last one turn later",
		"damage multiplier": 1.0
	},
	"Take a ride.": {
		"description": "When allies are hit by you, teleport them to a gate",
		"damage multiplier": 1.0
	},
	"Teethed to the arm.": {
		"description": "Bitten units will move together with you",
		"damage multiplier": 1.0
	},
	"Fast runner": {
		"description": "Heals adjacent allies and hurts adjacent enemies at the end of movement",
		"damage multiplier": 1.0
	},
	"Kleptomaniac": {
		"description": "Gains attack each time you disable a unit",
		"damage multiplier": 1.0
	},
	"Pigeon Rider": { # bird shit is a one way portal when you hit a wet enemy
		"description": "Makes adjacent enemies wet for 2 turns at the end of movement",
		"damage multiplier": 1.0
	},
	"Don't touch my stuff": {
		"description": "If 2 or more tiles away from the vault for 2 turns, you go directly to jail for 3 turns\nDo not pass Go",
		"damage multiplier": 1.0
	},
	
}

var bigness_data = {
	"Big Glasses": {
		"skill": "Piercing Ray",
	},
	
	"Big Hood": {
		"skill": "Backstab",
	},

	"Big Biceps": {
		"skill": "Sweep Attack",
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print('do i reach here')
	reset_global() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func toggle_player_turn():
	if WHOSTURNISIT == "P2":
		WHOSTURNISIT = "P1"
	else:
		WHOSTURNISIT = "P2"
	return


func show_quest_info(tile: Object):
	var quest_ui_node: Object = get_tree().current_scene.get_node("UI/HBoxContainer/QuestInfo")
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
		unit.xp = 0
		await unit.level_up()

func reset_global():
	round = 1
	score = {
		"P1" : 0,
		"P2" : 0
	}
	WHOSTURNISIT = "P1"
	
