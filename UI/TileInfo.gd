extends Control

func update_info(terrain_type : String, defense : int, movement_penalty : int):
	%TerrainLabel.text = terrain_type
	%TerrainIcon.texture = load(str("res://Assets/Terrain/", terrain_type, ".png"))
	%DefenseLabel.text = str("DEF : ",  defense)
