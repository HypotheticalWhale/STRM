extends MarginContainer

var passive_container_scene = preload("res://UI/PassiveModal.tscn")
var skill_container_scene = preload("res://UI/SkillModal.tscn")
var passive_cont
var skill_cont
@onready var button_press = %ButtonPressSound
func update_selected_job_details():
	var new_job = get_parent().get_parent().selected_tile.occupied_by["unit"]
	%Background.text = new_job.description
	if new_job.get_node("RedSprite").visible:
		%InfoSprite.texture = new_job.get_node("RedSprite").texture
	else:
		%InfoSprite.texture = new_job.get_node("BlueSprite").texture
	%ClassInformation.text = new_job.NAME
	var passives_container = $PanelContainer/VBoxContainer/HBoxContainer2/PassiveContainer/Passives
	var skills_container = $PanelContainer/VBoxContainer/HBoxContainer2/SkillContainer/Skills
	for child in skills_container.get_children():
		child.queue_free()
	for skill in new_job.ACTIONS:
		skill_cont = skill_container_scene.instantiate()
		skill_cont.text = skill
		skill_cont.tooltip_text = Globals.skills[skill]["description"]
		skills_container.add_child(skill_cont)
	for child in passives_container.get_children():
		child.queue_free()
	if len(new_job.get_node("Jobs").get_children()) > 0:
		for passive in new_job.PASSIVES:
			passive_cont = passive_container_scene.instantiate()
			passive_cont.get_node("PassiveName").text = passive
			passive_cont.get_node("PassiveDescription").text = Globals.passives[passive].description
			passives_container.add_child(passive_cont)
	else:
		passive_cont = passive_container_scene.instantiate()
		passive_cont.get_node("PassiveName").text = "Noob"
		passive_cont.get_node("PassiveDescription").text = "You have no talents"
		passives_container.add_child(passive_cont)
	remove_child(new_job)

func _on_button_pressed():
	button_press.play()
	get_tree().paused = false
	visible = false
