extends BaseClass


func initialize_stats():
	CURRENT_HEALTH = 60
	MOVEMENT = 3
	

func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/LancerRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/LancerBlue.png")
