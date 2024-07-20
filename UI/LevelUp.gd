extends MarginContainer



func _on_confirm_pressed():
	get_tree().paused = false
	visible = false
