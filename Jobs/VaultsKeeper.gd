extends Job


func _ready():
	job_name = "Vaults Keeper"
	description = "Protects the inside of the mansion well."
	skill = "Call the guards!"	# Strong melee area attack
	passive = "Really tough."	# takes half damage
	potential_jobs = []
	MAX_HEALTH = 15
	MOVEMENT = 2
	DAMAGE = 10
	
