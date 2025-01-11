extends BaseClass


func initialize_stats():
	MAX_HEALTH = 60
	CURRENT_HEALTH = 60
	MOVEMENT = 3
	DAMAGE = 20
	xp = 0
	max_xp = 100
	CURRENT_JOB = "Servant"
	ACTIONS = ["Sweep Attack"]
	QUEST = "Fight"
	POTENTIAL_JOBS = ["Messenger", "Bell Boy", "Gardener"]


func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/ServantRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/ServantBlue.png")
