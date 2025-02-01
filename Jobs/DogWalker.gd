extends Job


func _ready():
	job_name = "Dog Walker"
	description = "Guards the dogs that guard the mansion."
	skill = "Go Fetch!"	# deploys a dog onto a tile that bites anything nearby
	passive = "Teethed to the arm."	# has dogs as arms. attacks do double damage
	QUEST = "Walking Dogs"
	POTENTIAL_JOBS = []
	MAX_HEALTH = 25
	MOVEMENT = 5
	DAMAGE = 10
