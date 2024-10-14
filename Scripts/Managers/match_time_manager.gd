extends Control

# time settings
@export var defaultMinutes := 0
@export var defaultSeconds := 45

# the actual time variables
var minutes : int
var seconds : int

# signal for timer finishing
signal matchEnded

# references for the timer and for the tow timer label
@onready var timer = $Timer
@onready var labelA = $"../TimerPresenter1"
@onready var labelB = $"../TimerPresenter2"

# time-setting on ready
func _ready():
	set_timer()

# updating the timer 
# actually, we have a one secons timer, and we update that
func update_timer():
	if seconds == 0:
		if minutes > 0:
			# backtracking for a minute
			minutes -= 1
			seconds = 59
			
			# zhowing the time in the labels
			labelA.text = format_time(minutes, seconds)
			labelB.text = format_time(minutes, seconds)
			
			# refreshing
			timer.start(1.0)
		else:
			# 00:00 case - timeout
			# stopping the time, and emmitting signal
			timer.stop()
			matchEnded.emit()
	else:
		
		# time decreasing
		seconds -= 1
		
		# showing the time in the labels
		labelA.text = format_time(minutes, seconds)
		labelB.text = format_time(minutes, seconds)
		
		# refresh
		timer.start(1.0)

# timer setting
func set_timer():
	minutes = defaultMinutes
	seconds = defaultSeconds
	
	# Showing the time in the labels
	labelA.text = format_time(minutes, seconds)
	labelB.text = format_time(minutes, seconds)
	

# updating in every minutes
func _on_timer_timeout():
	update_timer()

# writing the time in mm:ss format
func format_time(minutes: int, seconds: int) -> String:
	# Format minutes and seconds to always be two digits
	return pad_zeros(minutes, 2) + " : " + pad_zeros(seconds, 2)

# helper function for padding zeros
# assisted by GPT
func pad_zeros(num: int, total_length: int) -> String:
	var num_str = str(num)
	while num_str.length() < total_length:
		num_str = "0" + num_str
	return num_str

# pausing the timer (after scoring a goal)
func pause():
	timer.stop()	
	
	# Waiting for 5 seconds
	await get_tree().create_timer(4.5).timeout
	
	# Restart
	timer.start(1.0)

# starting the timer (using from game manager to start the timer)
func start():
	timer.start(1.0)
