extends Job


func _ready():
	job_name = "Charioteer"
	description = "Rides a magnificent golden chariot."
	skill = "I love gates"	# attacks and moves in front after attack
	passive = "Take a ride."	#move whole team forward?
	QUEST = "Chariot Boy"
	POTENTIAL_JOBS = []
	MAX_HEALTH = 15
	MOVEMENT = 6
	DAMAGE = 10
