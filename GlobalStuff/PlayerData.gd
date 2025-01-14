extends Node

var player1_units = {
	"unit1" : null,
	"unit2" : null,
	"unit3" : null,	
}
var player2_units = {
	"unit1" : null,
	"unit2" : null,
	"unit3" : null,	
}
#var available_units = ["res://Classes/Servant.tscn", "res://Classes/Noble.tscn", "res://Classes/Entertainer.tscn"]
var available_units = ["res://Classes/Servant.tscn"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_units():
	player1_units["unit1"] = get_random_unit()
	player1_units["unit1"].TEAM = "P1"
	player1_units["unit2"] = get_random_unit()
	player1_units["unit2"].TEAM = "P1"
	player1_units["unit3"] = get_random_unit()
	player1_units["unit3"].TEAM = "P1"
	
	player2_units["unit1"] = get_random_unit()
	player2_units["unit1"].TEAM = "P2"
	player2_units["unit2"] = get_random_unit()
	player2_units["unit2"].TEAM = "P2"
	player2_units["unit3"] = get_random_unit()
	player2_units["unit3"].TEAM = "P2"

	
func get_random_unit():
	randomize()
	var rand_index = randi_range(0,len(available_units)-1)
	var unit = load(available_units[rand_index])
	var unit_instance = unit.instantiate()
	return unit_instance
