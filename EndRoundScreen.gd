extends PanelContainer

var player_won = false

func initialize(team: String, next_action: String):
	if next_action == "continue":
		%PlayerWon.text = team + " WINS"
		%PlayerLost.text = "LOSERS"

		if team == "P1":
			await %WinnerUnit1VBox.show_unit_info(PlayerData.player1_units["unit1"])
			await %WinnerUnit2VBox.show_unit_info(PlayerData.player1_units["unit2"])
			await %WinnerUnit3VBox.show_unit_info(PlayerData.player1_units["unit3"])

			await %LoserUnit1VBox.show_unit_info(PlayerData.player2_units["unit1"])
			await %LoserUnit2VBox.show_unit_info(PlayerData.player2_units["unit2"])
			await %LoserUnit3VBox.show_unit_info(PlayerData.player2_units["unit3"])

		if team == "P2":
			await %WinnerUnit1VBox.show_unit_info(PlayerData.player2_units["unit1"])
			await %WinnerUnit2VBox.show_unit_info(PlayerData.player2_units["unit2"])
			await %WinnerUnit3VBox.show_unit_info(PlayerData.player2_units["unit3"])

			await %LoserUnit1VBox.show_unit_info(PlayerData.player1_units["unit1"])
			await %LoserUnit2VBox.show_unit_info(PlayerData.player1_units["unit2"])
			await %LoserUnit3VBox.show_unit_info(PlayerData.player1_units["unit3"])
			pass
			
		player_won = false
		return
	
	if next_action == "end":
		%PlayerWon.text = team + " WINS"
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
