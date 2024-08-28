extends Job


func _ready():
	job_name = "Charioteer"
	description = "Rides a magnificent golden chariot."
	skill = "Golden Crash."	# attacks and moves in front after attack
	passive = "Take a ride."	#move whole team forward?
	potential_jobs = []
	MOVEMENT = 4
	DAMAGE = 10
