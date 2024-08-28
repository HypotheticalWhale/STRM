extends Job


func _ready():
	job_name = "Charioteer"
	description = "Rides a magnificent golden chariot."
	skill = "Golden Crash."	# attacks and moves in front after attack
	passive = "Take a ride."	#move whole team forward?
	potential_jobs = []
	MAX_HEALTH = 10
	MOVEMENT = 4
	DAMAGE = 10
