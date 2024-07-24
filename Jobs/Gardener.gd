extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "gardener"
	description = "Specializes in pruning trees and hooligans."
	skill = "trim_bushes"
	passive = "green_thumbs"
	potential_jobs = ["lawnsguard", "dog_handler", "card_soldier"]
