extends BaseClass


func initialize_stats():
	MAX_HEALTH = 60
	CURRENT_HEALTH = 60
	MOVEMENT = 2
	DAMAGE = 10
	ACTIONS = ["Sweep Attack"]
	QUEST = "fight"
	POTENTIAL_JOBS = ["gardener", "gardener", "gardener"]


func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/ServantRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/ServantBlue.png")



