extends PanelContainer

func initialize(team: String, next_action: String):
	if next_action == "continue":
		%PlayerWon.text = team + " wins this round. Go next."
		return
	
	if next_action == "end":
		%PlayerWon.text = team + " wins the round and the game. Play again?"
		return


func _on_end_round_button_pressed() -> void:
	Globals.round += 1
	Globals.score[Globals.WHOSTURNISIT] += 1
	await get_tree().current_scene.reset_units()
	get_tree().current_scene.turn_timer.stop()
	await get_tree().current_scene._on_turn_timer_timeout()
	get_tree().current_scene.turn_timer.start()
	visible = false
