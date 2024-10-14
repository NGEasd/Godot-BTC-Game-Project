# Based on enemy_disc_updated
# Has better medium diffficulity stats, like speed and shot power
# Only used in level 14, skating park

extends RigidBody2D

# AI Difficulty Levels
enum Difficulty { EASY, MEDIUM, HARD }

# States
enum State { CHASE, DEFEND, ATTACK, ULTRA_DEFEND, BASIC }

# AI attributes
@export var speed : float
@export var reactionTime : float
@export var accuracy : float
var kickPower : float
@export var difficulty : Difficulty

# Actual and initial settings
var currentState : State = State.ATTACK
var initialPosition : Vector2
var isEnabled : bool = true

# For the next target
var targetPosition : Vector2

# For the reset
var isResetting : bool = false

# References for the components of the game
@onready var ball = $"../SimpleBall"
@onready var opponentGoal = $"../MyGoalZone"
@onready var ownGoal = $"../EnemyGoalZone"

# Timer node
@onready var reactionTimer : Timer = $Timer

func _ready():
	set_difficulty(difficulty)
	initialPosition = global_position
	targetPosition = ball.position
	isResetting = false
	reactionTimer.wait_time = reactionTime
	reactionTimer.start()

# Function which sets the enemy stats 
func set_difficulty(difficulty: Difficulty) -> void:
	self.difficulty = difficulty
	match difficulty:
		Difficulty.EASY:
			speed = 300
			reactionTime = 1.0
			accuracy = 0.5
			kickPower = 100
		Difficulty.MEDIUM:
			speed = 650
			reactionTime = 0.5
			accuracy = 0.75
			kickPower = 100
		Difficulty.HARD:
			speed = 600
			reactionTime = 0.2
			accuracy = 0.9
			kickPower = 100
	reactionTimer.wait_time = reactionTime
	reactionTimer.start()

func enable() -> void:
	isEnabled = true
	self.sleeping = false
	targetPosition = ball.position + Vector2(100, 0)
	determine_action()

func disable() -> void:
	isEnabled = false

# Reset the enemy`s position to initial after scoring via reset state variable
func reset() -> void:
	isResetting = true

func determine_action() -> void:
	if !isEnabled:
		return 
	
	if ball.position.y > ownGoal.position.y + 250:
		if is_ball_behind():
			currentState = State.ULTRA_DEFEND
		else:
			currentState = State.DEFEND
	elif ball.position.y < ownGoal.position.y + 150:
		if ball.position.distance_to(opponentGoal.position) < 150 and is_ball_near_opponent():
			currentState = State.ATTACK
		else:
			currentState = State.BASIC
	else:
		currentState = State.BASIC

	handle_state()

func handle_state() -> void:
	match currentState:
		State.DEFEND:
			handle_defend_state()
		State.ATTACK:
			handle_attack_state()
		State.ULTRA_DEFEND:
			handle_ultra_defend_state()
		State.BASIC:
			handle_basic_state()

	if targetPosition == null:
		targetPosition = ball.position

func handle_defend_state() -> void:
	targetPosition = ball.position

func handle_attack_state() -> void:
	targetPosition = ball.position
	if global_position.distance_to(ball.position) < 50:
		var kickDirection = (opponentGoal.position - ball.position).normalized()
		ball.apply_central_impulse(kickDirection * kickPower)

func handle_ultra_defend_state() -> void:
	var avoidance_direction : Vector2

	if global_position.x > ball.position.x:
		avoidance_direction = Vector2(-1, 0) # Left
	else:
		avoidance_direction = Vector2(1, 0) # Right
	targetPosition = ownGoal.position + avoidance_direction * 150

func handle_basic_state() -> void:
	var direction_to_ball = (ball.position - global_position).normalized()
	var jitter = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	targetPosition = global_position + direction_to_ball * speed + jitter

func is_ball_behind() -> bool:
	return ball.position.y < global_position.y

func is_ball_near_opponent() -> bool:
	return ball.position.distance_to(opponentGoal.position) < 150

func _integrate_forces(state):
	if isResetting:
		state.transform = Transform2D(0.0, initialPosition)
		targetPosition = self.position
		currentState = State.DEFEND
		isResetting = false
	elif isEnabled:
		var direction = (targetPosition - global_position).normalized()
		linear_velocity = direction * speed
		
		# Check for ball contact and apply impulse
		for i in range(state.get_contact_count()):
			var contact_collider = state.get_contact_collider_object(i)
			if contact_collider and contact_collider.name == "SimpleBall":
				var contact_point = state.get_contact_local_position(i)
				var kickDirection = (contact_collider.get_global_position() - contact_point).normalized()
				contact_collider.apply_central_impulse(kickDirection * kickPower)

# Reaction management
func _on_timer_timeout():
	if isEnabled:
		determine_action()

func get_speed() -> Vector2:
	return linear_velocity
