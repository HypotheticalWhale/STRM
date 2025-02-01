extends Job


# Called when the node enters the scene tree for the first time.
func _ready():
	job_name = "Bell Boy"
	description = "Charming, disarming lad."
	skill = "Your weapons, please."	# displaces target unit by 2 squares and disables them
	passive = "Kleptomaniac"	# anytime he does damage, he gains attack
	POTENTIAL_JOBS = ["Butler", "Vaults Keeper", "Charioteer"]
	MAX_HEALTH = 20
	MOVEMENT = 4
	DAMAGE = 0
	QUEST = "Let me show you to your room"
