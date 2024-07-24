extends MarginContainer



func _on_confirm_pressed():
	get_tree().paused = false
	visible = false


func update_jobs(new_jobs : Array[String]):
	randomize()
	new_jobs.shuffle()
	for button in %JobButtons.get_children():
		print("should decrease, ", len(new_jobs))
		button.text = new_jobs.pop_front()
