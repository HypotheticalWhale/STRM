extends BaseClass


func initialize_stats():
	MAX_HEALTH = 60
	CURRENT_HEALTH = 60
	MOVEMENT = 3
	#MOVEMENT = 20
	DAMAGE = 10
	xp = 0
	max_xp = 100
	CURRENT_JOB = "Servant"
	
	randomize()
	var bigness_list = Globals.bigness_data.keys()
	bigness_list.shuffle()
	BIGNESS = bigness_list[0]
	ACTIONS = [Globals.bigness_data[BIGNESS]["skill"]]
	QUEST = "Fight"
	POTENTIAL_JOBS = ["Messenger", "Bell Boy", "Gardener"]


func initialize_sprites():
	if BIGNESS == "Big Biceps":
		$RedSprite.texture = load("res://Assets/Sprites/Units/BigBicepServantRed.png")
		$BlueSprite.texture = load("res://Assets/Sprites/Units/BigBicepServantBlue.png")
	if BIGNESS == "Big Hood":
		$RedSprite.texture = load("res://Assets/Sprites/Units/BigCloakServantRed.png")
		$BlueSprite.texture = load("res://Assets/Sprites/Units/BigCloakServantBlue.png")
	if BIGNESS == "Big Glasses":
		$RedSprite.texture = load("res://Assets/Sprites/Units/BigGlassesServantRed.png")
		$BlueSprite.texture = load("res://Assets/Sprites/Units/BigGlassesServantBlue.png")
		
		
