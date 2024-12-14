extends PanelContainer

func update_info(terrain_type : String, defense : int, movement_penalty : int):
	%TerrainLabel.text = terrain_type
	var terrain_type_no_spaces = ""
	for char in terrain_type:
		if char == " ":
			continue
		terrain_type_no_spaces += char
	%TerrainIcon.texture = load(str("res://Assets/Terrain/", terrain_type_no_spaces, ".png"))
	%DefenseLabel.text = str("DEF : ",  defense)
