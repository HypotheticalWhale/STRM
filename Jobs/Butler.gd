extends Job


func _ready():
	job_name = "Butler"
	description = "The pinnacle of mansion security."
	skill = "Have some tea, young master."	# displaces enemies into a tea party
	passive = "No hooligans allowed."	# 
	potential_jobs = []
	MAX_HEALTH = 10
	MOVEMENT = 3
	DAMAGE = 5
