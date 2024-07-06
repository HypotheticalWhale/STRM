extends TextureRect

var time_left_ratio : float

func _ready():
	texture = load("res://Assets/UI/Timer/Timer0.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_left_ratio = $TurnTimer.time_left / $TurnTimer.wait_time
	if time_left_ratio < float(5)/6:
		texture = load("res://Assets/UI/Timer/Timer1.png")
	if time_left_ratio < float(4)/6:
		texture = load("res://Assets/UI/Timer/Timer2.png")
	if time_left_ratio < float(3)/6:
		texture = load("res://Assets/UI/Timer/Timer3.png")
	if time_left_ratio < float(2)/6:
		texture = load("res://Assets/UI/Timer/Timer4.png")
	if time_left_ratio < float(1)/6:
		texture = load("res://Assets/UI/Timer/Timer5.png")
