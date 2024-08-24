extends BaseClass


func initialize_stats():
	MAX_HEALTH = 60
	CURRENT_HEALTH = 60
	MOVEMENT = 2
	DAMAGE = 10
	xp = 0
	max_xp = 50
	CURRENT_JOB = "Servant"
	ACTIONS = ["Sweep Attack"]
	QUEST = "fight"
	POTENTIAL_JOBS = ["Gardener", "Bell Boy", "Messenger"]


func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/ServantRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/ServantBlue.png")
