extends BaseClass


func initialize_stats():
	CURRENT_HEALTH = 60
	MOVEMENT = 3
	ACTIONS = ["SweepAttack","PoopyTest"]
	QUEST = "fight"
	POTENTIAL_JOBS = ["gardener", "gardener", "gardener"]


func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/ServantRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/ServantBlue.png")



