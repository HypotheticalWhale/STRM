extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Messenger"
	description = "Used to be a triathlete."
	skill = "Fleet-footed Kick."
	passive = "Fast runner"
	potential_jobs = ["Charioteer", "Pigeon Commander", "Dog Walker"]
	
