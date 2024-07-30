extends BaseClass


func initialize_stats():
	CURRENT_HEALTH = 60
	MOVEMENT = 4
	ACTIONS = ["Backstab"]
	
func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/AssassinRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/AssassinBlue.png")
