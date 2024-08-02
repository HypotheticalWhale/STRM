extends MarginContainer

var selected_job : String
var unit_to_level : Object

func _on_confirm_pressed():
	await unit_to_level.add_job(selected_job)
	get_tree().paused = false
	visible = false


func update_jobs(new_jobs : Array[String]):
	randomize()
	new_jobs.shuffle()
	for button in %JobButtons.get_children():
		if button.is_in_group("JobButtons") == false:
			continue
		button.job = new_jobs.pop_front()
		button.update_textures()


func set_selected_job(new_job : String):
	selected_job = new_job


func update_selected_job_details():
	var new_job = load(Globals.jobs[selected_job]).instantiate()
	add_child(new_job)
	%JobDescription.text = new_job.description
	%SkillInfo.text = new_job.skill
	%PassiveInfo.text = new_job.passive
	remove_child(new_job)
