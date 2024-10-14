# Note: this is the initial, 'noob' version of AI, used on level 1-4 (and boss)
# Assisted by GPT

extends RigidBody2D

# AI Difficulity Levels
enum Difficulty { EASY, MEDIUM, HARD }

# States
enum State { CHASE, DEFEND, ATTACK }

# AI attributes
@export var speed : float
@export var reactionTime : float
@export var accuracy : float
var kickPower : float
@export var difficulty : Difficulty

# Actual and initial settings
var currentState : State = State.ATTACK
var initialPosition : Vector2
var isEnabled : bool = false

# For the next target
var targetPosition : Vector2

# For the reset
var isResetting : bool = false

# Referencees for the components of the game
@onready var ball = $"../SimpleBall"
@onready var opponentGoal = $"../MyGoalZone"
@onready var ownGoal = $"../EnemyGoalZone"

# Timer node
@onready var reactionTimer : Timer = $Timer

func _ready():
	set_difficulty(difficulty)
	initialPosition = global_position
	isResetting = false
	reactionTimer.wait_time = reactionTime
	reactionTimer.start()

# Function which sets the enemy stats 
func set_difficulty(difficulty: Difficulty) -> void:
	self.difficulty = difficulty
	match difficulty:
		Difficulty.EASY:
			speed = 200
			reactionTime = 1.0
			accuracy = 0.5
			kickPower = 40
		Difficulty.MEDIUM:
			speed = 300
			reactionTime = 0.5
			accuracy = 0.75
			kickPower = 50
		Difficulty.HARD:
			speed = 450
			reactionTime = 0.1
			accuracy = 1
			kickPower = 60
	reactionTimer.wait_time = reactionTime
	reactionTimer.start()

# Enable/Disable functions
func enable() -> void:
	isEnabled = true
	self.sleeping = false

func disable() -> void:
	isEnabled = false

# Reset the enemy`s position to initial after scoring via reset state variable
func reset() -> void:
	isResetting = true
	self.sleeping = false

# Reacting for game situations
func determine_action() -> void:
	match currentState:
		State.CHASE:
			handle_chase_state()
		State.DEFEND:
			handle_defend_state()
		State.ATTACK:
			handle_attack_state()

# Case chasing
func handle_chase_state() -> void:
	targetPosition = ball.position
	if global_position.distance_to(ball.position) < 50:
		currentState = State.ATTACK
	elif ball.position.distance_to(ownGoal.position) < 200:
		currentState = State.DEFEND

# Defending
func handle_defend_state() -> void:
	# Logics: remaining between the enemy goal and the ball
	targetPosition = ownGoal.position + (ball.position - ownGoal.position).normalized() * 100
	if ball.position.distance_to(ownGoal.position) > 200:
		currentState = State.CHASE

# Attacking
func handle_attack_state() -> void:
	# Target the player`s goal
	targetPosition = opponentGoal.position
	if ball.position.distance_to(opponentGoal.position) > 200:
		currentState = State.CHASE

# Managing movements via target position managed by handling functions
func _integrate_forces(state):
	if isResetting:
		state.transform = Transform2D(0.0, initialPosition)
		targetPosition = self.position
		currentState = State.DEFEND
		isResetting = false
	if isEnabled:
		var direction = (targetPosition - global_position).normalized()
		linear_velocity = direction * speed
		# Kicking mechanism
		for i in range(state.get_contact_count()):
			var objectum = state.get_contact_collider_object(i) 
			if objectum.name == "SimpleBall":
				# Getting the contact point to calculate the normalvector, and the direction of kicking
				var contactPoint = state.get_contact_local_position(i)
				var kickDirection = (objectum.get_global_position() - contactPoint).normalized()
				objectum.apply_central_impulse(kickDirection * kickPower)

# Reaction management
func _on_timer_timeout():
	if isEnabled:
		determine_action()

func get_speed() -> Vector2:
	return linear_velocity
