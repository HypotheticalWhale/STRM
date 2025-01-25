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
var poshMedievalNames = [
  "Aelric Ravenscroft",
  "Adelina de Valois",
  "Alistair Wrenford",
  "Amalia DuMont",
  "Anselm Blackwood",
  "Aurelia Everhart",
  "Bartholomew Fairchild",
  "Beatrice Pembroke",
  "Benedict Thornevale",
  "Berenice Ravenshade",
  "Caius Thornewood",
  "Cecilia du Val",
  "Cedric de Montfort",
  "Clarissa Greyson",
  "Darius Halberg",
  "Dorothea Lancaster",
  "Edric Valemont",
  "Eleanor Ravensbrook",
  "Eldric Ashford",
  "Elisabeth Courtenay",
  "Emory Falconer",
  "Estelle de la Roche",
  "Felix of Arundel",
  "Florence Montclair",
  "Gideon Darkmore",
  "Gwyneth Farrington",
  "Hector Drakeswell",
  "Helena Dunsford",
  "Isabella Winterbourne",
  "Isidore Redgrave",
  "Jasper Langley",
  "Josephine Wyldemoor",
  "Lysander Ravenshade",
  "Lucinda Graves",
  "Magnus Stormholm",
  "Matilda Fitzroy",
  "Maximus Leclerc",
  "Melisande Wetherby",
  "Oliver Westlake",
  "Orlaith Wyndmoor",
  "Percival Hawke",
  "Philippa de Beaumont",
  "Reginald Blackthorne",
  "Rosalind Trevane",
  "Sebastian Vale",
  "Selene Everhart",
  "Sybilla Whitfield",
  "Theodore Gillingham",
  "Vivienne Arlesbury",
  "Wulfric Devereux",
  "Adelaide Fenwick",
  "Alaric Wintersmith",
  "Alden Ashcombe",
  "Alethea Ravenshade",
  "Annalise de la Croix",
  "Archibald Trevethick",
  "Aurelius Briarwood",
  "Beatrix Langford",
  "Benedict Blackthorn",
  "Benedicta Vexley",
  "Berengar Devereux",
  "Blythe Carrington",
  "Cassandra Wyvernwood",
  "Cassian Leclair",
  "Cecily Pemberton",
  "Crispin Ashford",
  "Cuthbert Ravenson",
  "Daphne Valmont",
  "Desmond Windward",
  "Dominic Loxley",
  "Dulcia Montague",
  "Edmund Vale",
  "Eleanora Dunsford",
  "Elfrida Thornton",
  "Emmeline Deschamps",
  "Errol Wellesley",
  "Esther Fitzhugh",
  "Evangeline Grey",
  "Felicia Kingswell",
  "Fitzwilliam Darrow",
  "Florence Montrose",
  "Garrett Windemere",
  "Genevieve Lancaster",
  "Giselle Vance",
  "Graham Wynton",
  "Gwendolyn Hatherleigh",
  "Hadrian Greystone",
  "Harriet Pembroke",
  "Henry Rotherham",
  "Hester Ravenswood",
  "Ignatius Sinclair",
  "Imogen Ravensdale",
  "Isidore Thornebrook",
  "Ivor Haldane",
  "Jemima Featherstone",
  "Julius Thistlewood",
  "Katherine Fairhurst",
  "Kendrick Halverston",
  "Lancelot Pendrake",
  "Lavinia Lancaster",
  "Leopold Wexler",
  "Lucian Hawthorne",
  "Lydia Windridge",
  "Marius Devereux",
  "Matilda Graystone",
  "Montague Beringer",
  "Nathalie Everglade",
  "Nicholas Merriweather",
  "Ophelia St. Clair",
  "Orlando Waverley",
  "Oswald Fairview",
  "Persephone Ashcombe",
  "Phineas Ravenscroft",
  "Quentin Malbury",
  "Reginald Blackwood",
  "Rosalie Vane",
  "Rowena de Montfort",
  "Rupert Stormhurst",
  "Seraphina Winthrope",
  "Simeon Waddington",
  "Sybilla Hawkesworth",
  "Theobald Brackmont",
  "Thérèse Leclair",
  "Theodora Carrington",
  "Thurstan Vexley",
  "Ursula Draycott",
  "Valentina Loxley",
  "Vernon Harroway",
  "Violet Ashcombe",
  "Wendell Crayford",
  "Wilhelmina Ravenscroft",
  "Wilfred Lockwood",
  "Xavier Carrington",
  "Ysabel Kingsley",
  "Zacharias Blackwood",
  "Adelaide Harrington",
  "Alistair de Vauban",
  "Amabel Ravensdale",
  "Anselm Thornewood",
  "Avery Fairchild",
  "Beatrice Langley",
  "Bernard Westford",
  "Briar Thornevale",
  "Celeste Leclair",
  "Cicely Ashford",
  "Claudia Ravenscroft",
  "Crispin Hawke",
  "Cyprian Wetherby",
  "Diana Blackthorne",
  "Dorian LeMarchand",
  "Elisabeth Hawkesbury",
  "Elisandra Trevane",
  "Felix Ravensbrook",
  "Finley Montrose",
  "Fiona Wexford",
  "Gareth Whitford",
  "Georgiana Blackstone",
  "Giles Pembroke",
  "Guinevere Stormgard",
  "Harold Fairmont",
  "Hestia Vane",
  "Iola Carrington",
  "Isla Hawkesworth",
  "Jasper Wyndmoor",
  "Jocelyn Grey",
  "Jolyon Darkmore",
  "Julian Thorndale",
  "Laetitia Armitage",
  "Laurence Thornfield",
  "Luciana Waverley",
  "Lysandra St. Clair",
  "Maximilian Wexler",
  "Meredith Arlesbury",
  "Nicolas Ravensbrook",
  "Oliver Briarwood",
  "Orlaith Everhart",
  "Peregrine Fairchild",
  "Penelope Westlake",
  "Phyllida Hawke",
  "Quentin Ashcombe",
  "Raphaela Blackthorn",
  "Roderick Wetherby",
  "Rosalind Montfort",
  "Rowena Draycott",
  "Selina Devereux",
  "Sebastian Gillingham",
  "Seraphina Ravensdale",
  "Simon Carrington",
  "Sophie Haldane",
  "Sylvanus Thornfield",
  "Theodore Westmore",
  "Thompson Ravenshade",
  "Valeria Windmere",
  "Vere Thornton",
  "Victor Hawkesbury",
  "Vivienne Lancaster",
  "Wesley Wexler",
  "Wilhelmina Hatherleigh",
  "Winston Pembroke"
]
#var available_units = ["res://Classes/Servant.tscn", "res://Classes/Noble.tscn", "res://Classes/Entertainer.tscn"]
var available_units = ["res://Classes/Servant.tscn"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func generate_random_name():
	randomize()
	poshMedievalNames.shuffle()
	return poshMedievalNames[0]
	
func create_units():
	player1_units["unit1"] = get_random_unit()
	player1_units["unit1"].TEAM = "P1"
	player1_units["unit1"].NAME = generate_random_name()
	
	player1_units["unit2"] = get_random_unit()
	player1_units["unit2"].TEAM = "P1"
	player1_units["unit2"].NAME = generate_random_name()
	
	player1_units["unit3"] = get_random_unit()
	player1_units["unit3"].TEAM = "P1"
	player1_units["unit3"].NAME = generate_random_name()
	
	player2_units["unit1"] = get_random_unit()
	player2_units["unit1"].TEAM = "P2"
	player2_units["unit1"].NAME = generate_random_name()
	
	player2_units["unit2"] = get_random_unit()
	player2_units["unit2"].TEAM = "P2"
	player2_units["unit2"].NAME = generate_random_name()
	
	player2_units["unit3"] = get_random_unit()
	player2_units["unit3"].TEAM = "P2"
	player2_units["unit3"].NAME = generate_random_name()

	
func get_random_unit():
	randomize()
	var rand_index = randi_range(0,len(available_units)-1)
	var unit = load(available_units[rand_index])
	var unit_instance = unit.instantiate()
	return unit_instance
