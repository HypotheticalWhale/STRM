extends BaseClass


func initialize_stats():
	MAX_HEALTH = 40
	CURRENT_HEALTH = 40
	DAMAGE = 10
	MOVEMENT = 4
	ACTIONS = ["Backstab"]
	
func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/AssassinRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/AssassinBlue.png")
