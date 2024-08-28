extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Messenger"
	description = "Used to be a triathlete."
	skill = "Fleet-footed Kick."	# dashes two squares (in one of 8 directions)
	passive = "Fast runner"		# at the end any movement/active, deal damage to all adjacent units
	potential_jobs = ["Charioteer", "Pigeon Commander", "Dog Walker"]
	MOVEMENT = 3
	DAMAGE = 5
