extends BaseClass


func initialize_stats():
	MAX_HEALTH = 10
	CURRENT_HEALTH = 10
	DAMAGE = 10
	MOVEMENT = 10
	CURRENT_JOB = "Noble"
	ACTIONS = ["Piercing Ray"]
	QUEST = "Hands-off Approach"
	xp = 0
	max_xp = 500
func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/NobleRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/NobleBlue.png")
