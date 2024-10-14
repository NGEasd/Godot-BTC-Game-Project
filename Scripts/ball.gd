extends RigidBody2D

# variables for resetting the position of the ball
var defaultPosition = Vector2.ZERO
var resetState := false

# setting the ball properties
func _ready():
	defaultPosition = global_position
	linear_damp = 0.8
	angular_damp = 0.8

# reset via this built-in function
func _integrate_forces(state):
	if resetState:
		# Reset velocity and angular velocity
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
		global_position = defaultPosition
		resetState = false

# changing the reset state
func reset():
	resetState = true
	self.sleeping = false # ensures that the _integrate_forces function will work
