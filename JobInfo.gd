extends MarginContainer


func update_selected_job_details():
	var new_job = get_parent().get_parent().selected_tile.occupied_by["unit"]
	%Background.text = new_job.description
	%Skill.text = new_job.skill
	
	%Passive.text = new_job.passive
	if new_job.passive != "Noob":
		%PassiveD.text = Globals.passives[new_job.passive].description
	else:
		%PassiveD.text = "You're remarkably untalented"
	remove_child(new_job)
	
func _on_button_pressed():
	get_tree().paused = false
	visible = false

