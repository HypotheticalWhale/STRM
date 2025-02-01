extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Gardener"
	description = "Specializes in pruning trees and hooligans."
	skill = "Trim Bushes"	# big area attack with a sweet spot at the intersection of scissors
	passive = "Green Thumbs"	# deals more damage in garden
	POTENTIAL_JOBS = ["Vaults Keeper", "Dog Walker", "Card Soldier"]
	MAX_HEALTH = 30
	MOVEMENT = 3
	DAMAGE = 5
	QUEST = "Landscaping"
