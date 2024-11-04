extends BaseClass


func initialize_stats():
	MAX_HEALTH = 60
	CURRENT_HEALTH = 60
	MOVEMENT = 3
	DAMAGE = 20
	xp = 0
	max_xp = 100
	CURRENT_JOB = "Servant"
	ACTIONS = ["Sweep Attack", "Tea Party for Two"]
	QUEST = "Fight"
	POTENTIAL_JOBS = ["Charioteer", "Bell Boy", "Dog Walker"]


func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/ServantRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/ServantBlue.png")
