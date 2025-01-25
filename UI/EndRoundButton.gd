extends Button


func _on_pressed():
	Globals.round += 1
	Globals.score[Globals.WHOSTURNISIT] += 1
	await get_parent().get_parent().reset_units()
	get_parent().get_parent().turn_timer.stop()
	await get_parent().get_parent()._on_turn_timer_timeout()
	get_parent().get_parent().turn_timer.start()
	visible = false
	#reset positions
	#round intermission ui
	
