extends BaseClass


func initialize_stats():
	CURRENT_HEALTH = 80
	MOVEMENT = 2

func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/PyromancerRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/PyromancerBlue.png")
