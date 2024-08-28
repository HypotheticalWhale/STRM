extends Job


func _ready():
	job_name = "Dog Walker"
	description = "Guards the dogs that guard the mansion."
	skill = "Get'em, Woofy McDog!"	# deploys a dog onto a tile that bites anything nearby
	passive = "Teethed to the arm."	# has dogs as arms. attacks do double damage
	potential_jobs = []
	MAX_HEALTH = 5
	MOVEMENT = 3
	DAMAGE = 10
