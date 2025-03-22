extends PanelContainer

var player_won = false
@onready var button_press = %ButtonPressSound

func initialize(team: String, next_action: String):
	button_press.play()	
	if next_action == "continue":
		%PlayerWon.text = team + " wins this round. Go next."
		player_won = false
		return
	
	if next_action == "end":
		%PlayerWon.text = team + " wins the round and the game. Play again?"
		player_won = true
		return


func _on_end_round_button_pressed() -> void:
	if player_won == true:
		var _reload = await get_tree().reload_current_scene()
		return
	Globals.round += 1
	Globals.score[Globals.WHOSTURNISIT] += 1
	await get_tree().current_scene.reset_units()
	get_tree().current_scene.turn_timer.stop()
	await get_tree().current_scene._on_turn_timer_timeout()
	get_tree().current_scene.turn_timer.start()
	visible = false

