extends Button
@onready var button_press = %ButtonPressSound

func _on_pressed():
	button_press.play()
	get_tree().paused = false
	visible = false
