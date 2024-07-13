extends PanelContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(int($TurnTimer.time_left))
	
