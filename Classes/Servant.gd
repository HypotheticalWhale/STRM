extends BaseClass


func initialize_stats():
	MAX_HEALTH = 60
	CURRENT_HEALTH = 60
	#MOVEMENT = 3
	MOVEMENT = 20
	DAMAGE = 10
	xp = 0
	max_xp = 100
	CURRENT_JOB = "Servant"
	
	randomize()
	var bigness_list = Globals.bigness_data.keys()
	bigness_list.shuffle()
	var new_bigness = bigness_list[0]
	ACTIONS = [Globals.bigness_data[new_bigness]["skill"]]
	QUEST = "Fight"
	POTENTIAL_JOBS = ["Messenger", "Bell Boy", "Gardener"]


func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/ServantRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/ServantBlue.png")
