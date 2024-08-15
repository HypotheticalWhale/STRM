extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Lawns Guard"
	description = "He guards the lawn"
	skill = "Circular Strike"
	passive = "Big and Durable"
	potential_jobs = ["Lawns Guard", "Dog Walker", "Card Soldier"]
