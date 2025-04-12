extends PanelContainer

var player_won = false
@onready var button_press = %ButtonPressSound

func initialize(team: String, next_action: String):
	button_press.play()	
	if next_action == "continue":
		%LoserPanelContainer.visible = true
		%PlayerWon.text = team + " WINS THE ROUND"
		%EndRoundButton.text = "TO THE NEXT!"
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
		%LoserPanelContainer.visible = false
		%PlayerWon.text = team + " WINS THE GAME"
		%EndRoundButton.text = "START NEW GAME"
		player_won = true
		return		
	

func _on_end_round_button_pressed() -> void:
	if player_won == true:
		get_tree().change_scene_to_file("res://StartScreen.tscn")
		return
	Globals.round += 1
	Globals.score[Globals.WHOSTURNISIT] += 1
	await get_tree().current_scene.reset_units()
	get_tree().current_scene.turn_timer.stop()
	get_tree().current_scene.turn_timer.start()
	visible = false
