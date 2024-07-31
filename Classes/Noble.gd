extends BaseClass


func initialize_stats():
	MAX_HEALTH = 30
	CURRENT_HEALTH = 30
	DAMAGE = 10
	MOVEMENT = 1
	ACTIONS = ["Piercing Ray"]
func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/NobleRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/NobleBlue.png")
