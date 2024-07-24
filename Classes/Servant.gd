extends BaseClass


func initialize_stats():
	CURRENT_HEALTH = 60
	MOVEMENT = 3
	ACTIONS = ["Sweep Attack","Poopy Test"]
	QUEST = "fight"


func initialize_sprites():
	$RedSprite.texture = load("res://Assets/Sprites/Units/ServantRed.png")
	$BlueSprite.texture = load("res://Assets/Sprites/Units/ServantBlue.png")



