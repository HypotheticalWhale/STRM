extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Bell Boy"
	description = "Charming, disarming lad."
	skill = "Your weapons, please."	# displaces target unit by 2 squares and disables them
	passive = "Kleptomaniac"	# anytime he does damage, he gains attack
	potential_jobs = ["Butler", "Vaults Keeper", "Charioteer"]
	MAX_HEALTH = 5
	MOVEMENT = 3
	DAMAGE = 5
	QUEST = "Let me show you to your room"
