extends PanelContainer

func update_info(skill_name : String):
	%SkillHUDLabel.text = skill_name
	%SkillHUDDescription.text = Globals.skills[skill_name]["detailed info"]
