extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Vaults Keeper"
	description = "He guards the vault"
	skill = "Circular Strike"
	passive = "Big and Durable"
	potential_jobs = ["Vaults Keeper", "Dog Walker", "Card Soldier"]
