extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Gardener"
	description = "Specializes in pruning trees and hooligans."
	skill = "Trim Bushes"
	passive = "Green Thumbs"
	potential_jobs = ["Lawns Guard", "Dog Walker", "Card Soldier"]
