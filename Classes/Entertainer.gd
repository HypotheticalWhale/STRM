extends BaseClass


func initialize_stats():
	MAX_HEALTH = 40
	CURRENT_HEALTH = 40
	DAMAGE = 10
	MOVEMENT = 4
	xp = 0
	max_xp = 500
	CURRENT_JOB = "Entertainer"
	ACTIONS = ["Backstab"]
	
func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/AssassinRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/AssassinBlue.png")
