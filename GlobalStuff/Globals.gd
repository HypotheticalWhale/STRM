extends Node

const TILE_SIZE = 32
var WHOSTURNISIT = "P1"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func toggle_player_turn():
	if WHOSTURNISIT == "P2":
		WHOSTURNISIT = "P1"
	else:
		WHOSTURNISIT = "P2"
	return


func show_tile_info(tile : Object):
	if get_tree().current_scene.has_node("UI/TileInfo") == false:
		printerr("Not allowed to show tile_info in scene other than Main.tscn.")
		return
	var tile_info = get_tree().current_scene.get_node("UI/TileInfo")
	tile_info.visible = true
	tile_info.update_info(tile.get_terrain().type, tile.get_terrain().defense, tile.get_terrain().movement_penalty)

