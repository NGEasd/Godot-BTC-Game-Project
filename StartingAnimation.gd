extends Control

var countdown := 3
var finish := false
signal animation_finished

# Referencees for label, sounds and timer
@onready var label = $Countdown
@onready var beepSound = $Beep
@onready var kickoffSound = $KickOffSound
@onready var timer = $Timer

# Initially we hide all the labels
func _ready():
	label.hide()

# For every seconds, we show the next number
func _on_timer_timeout():
	if countdown > 0:
		beepSound.play()
		label.text = str(countdown)
		label.show()
		countdown -= 1
		timer.start(1.0)
	
	# If time finished, we play the kick-off sound
	elif countdown == 0:
		label.hide()
		kickoffSound.play()
		finish = true
		timer.stop()
		
		# Emiting a signal to the manager
		animation_finished.emit()

# Staring the timer
func start() -> void:
	timer.start(1.0)

# Geting the state of this animation
func finished() -> bool:
	return finish
