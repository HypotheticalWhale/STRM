extends Job


func _ready():
	job_name = "Pigeon Commander"
	description = "A walking post office."
	#skill = "I come with great news"
	# use messenger skill for debug
	skill = "Fleet-footed Kick."
	passive = "Pigeon Rider"
	potential_jobs = []
	MAX_HEALTH = 10
	MOVEMENT = 4
	DAMAGE = 8
	QUEST = "Smelliest guy on earth"
