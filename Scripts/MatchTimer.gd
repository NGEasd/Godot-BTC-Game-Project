extends Control

const def_minutes := 2
const def_seconds := 0
var min : int
var sec : int

@onready var timer = $Timer
@onready var label = $Label
@onready var manager


func _ready():
	manager = $".."

func update_timer():
	if sec == 0:
		if min > 0:
			min -= 1
			sec = 59
		else:
			manager.set_match_finished()
			timer.stop()
	else:
		sec -= 1
	label.text = format_time(min, sec)

func set_timer():
	min = def_minutes
	sec = def_seconds
	label.text = format_time(min, sec)

func _on_timer_timeout():
	update_timer()

func format_time(minutes: int, seconds: int) -> String:
	# Format minutes and seconds to always be two digits
	return pad_zeros(minutes, 2) + " : " + pad_zeros(seconds, 2)

# Helper function for padding zeros
func pad_zeros(num: int, total_length: int) -> String:
	var num_str = str(num)
	while num_str.length() < total_length:
		num_str = "0" + num_str
	return num_str
	
func pause():
	timer.stop()	
	await get_tree().create_timer(5.0).timeout
	print("The pause was succesfully managed!")
	timer.start()
	
func start():
	$Timer.start()
