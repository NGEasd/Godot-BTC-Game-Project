extends Control

# Constants for time mesuring
const defaultMinutes := 1
const defaultSeconds := 0

# The actual time variables
var minutes : int
var seconds : int

# Signal for timer finishing
signal matchEnded

# References for the timer and for the tow timer label
@onready var timer = get_node("/root/IceLevel1v1/MatchTimeManager/Timer")
@onready var labelA = get_node("/root/IceLevel1v1/TimerPresenter1")
@onready var labelB = get_node("/root/IceLevel1v1/TimerPresenter2")

# The ready function sets the timer
func _ready():
	set_timer()

# Updating the timer in every seconds
func update_timer():
	if seconds == 0:
		if minutes > 0:
			# Backtracking for a minute
			minutes -= 1
			seconds = 59
			
			# Showing the time in the labels
			labelA.text = format_time(minutes, seconds)
			labelB.text = format_time(minutes, seconds)
			
			# Refresh
			timer.start(1.0)
		else:
			
			# Stopping the time, and emmitting signal
			timer.stop()
			matchEnded.emit()
	else:
		
		seconds -= 1
		
		# Showing the time in the labels
		labelA.text = format_time(minutes, seconds)
		labelB.text = format_time(minutes, seconds)
		
		# Refresh
		timer.start(1.0)

# Default setting
func set_timer():
	minutes = defaultMinutes
	seconds = defaultSeconds
	
	# Showing the time in the labels
	labelA.text = format_time(minutes, seconds)
	labelB.text = format_time(minutes, seconds)
	

# Updating in every minutes
func _on_timer_timeout():
	update_timer()

# Writing the time in mm:ss format
func format_time(minutes: int, seconds: int) -> String:
	# Format minutes and seconds to always be two digits
	return pad_zeros(minutes, 2) + " : " + pad_zeros(seconds, 2)

# Helper function for padding zeros
func pad_zeros(num: int, total_length: int) -> String:
	var num_str = str(num)
	while num_str.length() < total_length:
		num_str = "0" + num_str
	return num_str

# Pausing the timer (after scoring a goal)
func pause():
	timer.stop()	
	
	# Waiting for 5 seconds
	await get_tree().create_timer(4.5).timeout
	
	# Restart
	timer.start(1.0)

# starting the timer (using from game manager to start the timer)
func start():
	timer.start(1.0)
