extends TextureButton

var job : String
@onready var LevelUpUI = get_tree().current_scene.get_node("UI/LevelUp")

func update_textures():
	var job_node = load(Globals.jobs[job]).instantiate()
	texture_normal = job_node.get_node("Uncolored").texture


func _on_pressed():
	await LevelUpUI.set_selected_job(job)
	await LevelUpUI.update_selected_job_details()
	LevelUpUI.get_node("PanelContainer/VBoxContainer/ChooseSkill").text = job
	
