extends Node

var player1_units = {
	"unit1" : "",
	"unit2" : "",
	"unit3" : "",	
}
var player2_units = {
	"unit1" : "",
	"unit2" : "",
	"unit3" : "",	
}
var available_units = ["res://Classes/Servant.tscn", "res://Classes/Noble.tscn", "res://Classes/Entertainer.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_units():
	player1_units["unit1"] = get_random_unit()
	player1_units["unit1"].TEAM = 1
	player1_units["unit2"] = get_random_unit()
	player1_units["unit2"].TEAM = 1
	player1_units["unit3"] = get_random_unit()
	player1_units["unit3"].TEAM = 1
	
	player2_units["unit1"] = get_random_unit()
	player2_units["unit1"].TEAM = 2
	player2_units["unit2"] = get_random_unit()
	player2_units["unit2"].TEAM = 2
	player2_units["unit3"] = get_random_unit()
	player2_units["unit3"].TEAM = 2

	
func get_random_unit():
	randomize()
	var rand_index = randi_range(0,len(available_units)-1)
	var unit = load(available_units[rand_index])
	var unit_instance = unit.instantiate()
	return unit_instance
