extends Label

@onready var turn_timer = %TurnTimer
@onready var timer_sprite = %TimerSprite
func _ready() -> void:
	timer_sprite.play_backwards()
func _process(delta: float) -> void:
	text = str(int(turn_timer.time_left)).pad_zeros(2)
	
