extends Area2D

var has_object : bool = false
var tile_coordinates
var occupied_by
@onready var highlighted_tile = $Selected
@onready var regular_tile = $NotSelected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_mouse_entered():
	highlighted_tile.visible = true


func _on_mouse_exited():
	highlighted_tile.visible = false


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("tile at ",tile_coordinates," is clicked")
		print("tile at ",tile_coordinates," has ", occupied_by)
