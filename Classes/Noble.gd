extends BaseClass


func initialize_stats():
	CURRENT_HEALTH = 80
	MOVEMENT = 1
	ACTIONS = ["Piercing Ray"]
func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/NobleRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/NobleBlue.png")
