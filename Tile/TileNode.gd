extends Area2D

var has_object : bool = false
var tile_coordinates
var occupied_by = {
	"unit" : "",
	"terrain": "",
}
@onready var highlighted_tile = $Selected
@onready var regular_tile = $NotSelected
@onready var available_tile = $Available
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_mouse_entered():
	highlighted_tile.visible = true


func _on_mouse_exited():
	highlighted_tile.visible = false


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Globals.show_tile_info(self)
		if occupied_by["unit"] and Globals.WHOSTURNISIT == occupied_by["unit"].TEAM:
			occupied_by["unit"].attack()	#debug only
			get_parent().show_select_menu(global_position,self)
			get_parent().clear_available_tiles()			
		elif occupied_by["unit"] and Globals.WHOSTURNISIT != occupied_by["unit"].TEAM:
			get_parent().show_info_menu(global_position,self)			
			get_parent().clear_available_tiles()			
		else:
			if available_tile.visible == true:
				occupied_by["unit"] = get_parent().selected_tile.occupied_by["unit"]
				get_parent().selected_tile.occupied_by["unit"].global_position = global_position
				
				get_parent().selected_tile.occupied_by["unit"] = ""
				
			get_parent().clear_available_tiles()						
			get_parent().hide_select_menu()
			get_parent().hide_info_menu()			
			
		print("tile at ",tile_coordinates," is clicked")
		print("tile at ",tile_coordinates," has ", occupied_by)

func toggle_available_tile():
	available_tile.visible = !available_tile.visible

func is_empty_tile():
	if occupied_by["unit"]:
		return true
		

func add_terrain(terrain_type : String):
	if terrain_type == "marble":
		var new_terrain = load("res://Terrain/Marble.tscn").instantiate()
		add_child(new_terrain)
		occupied_by["terrain"] = new_terrain
		
	if terrain_type == "garden":
		var new_terrain = load("res://Terrain/Garden.tscn").instantiate()
		add_child(new_terrain)
		occupied_by["terrain"] = new_terrain

	if terrain_type == "throne":
		var new_terrain = load("res://Terrain/Throne.tscn").instantiate()
		add_child(new_terrain)
		occupied_by["terrain"] = new_terrain

func get_terrain():
	return occupied_by["terrain"]
