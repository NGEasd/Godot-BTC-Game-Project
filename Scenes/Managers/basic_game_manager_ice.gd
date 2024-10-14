extends Node2D

# Variables for match tracking
var playerScore : int
var enemyScore : int
var goal : bool
var matchEnded : bool

# Score panels
@onready var playerScorePanelA := $"../ResultTableA1"
@onready var playerScorePanelB := $"../ResultTableA2"
@onready var enemyScorePanelA := $"../ResultTableB1"
@onready var enemyScorePanelB := $"../ResultTableB2"

# Players
@onready var player := $"../PlayerOne"
@onready var enemy := $"../PlayerTwo"

# Ball
@onready var ball := $"../SimpleBall"

# Timers
@onready var timer := $"../MatchTimeManager"

# Countdown animation
@onready var countdown := $StartingAnimation

# Match Finished Table and Results Manager
@onready var endPanel := $"../MatchEnded"

# Goal Animations
@onready var goalAnimationPlayer := $"../GoalAnimationPlayer"
@onready var goalAnimationEnemy := $"../GoalAnimationEnemy"

# Sounds
@onready var kickOffSound := $"../KickOffSound"
@onready var matchFinishedSound := $"../MatchFinishedSound"


# Initialiying
func _ready() -> void:
	
	player.disable()
	player.set_speed(750)
	
	enemy.disable()
	enemy.set_speed(750)
	
	playerScore = 0
	enemyScore = 0
	goal = false
	matchEnded = false
	
	if playerScorePanelA and playerScorePanelB:
		playerScorePanelA.text = str(playerScore)
		playerScorePanelB. text = str(playerScore)
	else:
		print("Player Score Panel don`t found!")
		
	if enemyScorePanelA and enemyScorePanelB:
		enemyScorePanelA.text = str(enemyScore)
		enemyScorePanelB. text = str(enemyScore)
	else:
		print("Enemy Score Panel don`t found!")
	
	if countdown:
		countdown.start()

# When the stating animation finished, we start the match
func _on_starting_animation_animation_finished():
	player.enable()
	enemy.enable()
	timer.start()

# Function for score managing
func add_goal(id : int) -> void:
	if not goal and not matchEnded:
		goal = true
		
		# 1 - player
		# 2 - enemy
		# Updating the scores and changing the numbers on the label
		match id:
			1: 
				enemyScore += 1
				enemyScorePanelA.text = str(enemyScore)
				enemyScorePanelB. text = str(enemyScore)
				goalAnimationEnemy.play()
			2:
				playerScore += 1
				playerScorePanelA.text = str(playerScore)
				playerScorePanelB. text = str(playerScore)
				goalAnimationPlayer.play()
		
		# Pausing the timer for 5 seconds
		await(timer.pause())
		
		# Reset the positions 
		await(player.reset())
		await(enemy.reset())
		ball.reset()
		
		# Playing the kickoff sound
		kickOffSound.play()
		goal = false

# deciding who is the winner
func winner() -> String:
	if playerScore > enemyScore:
		return "Player"
	elif enemyScore > playerScore:
		return "Enemy"
	else:
		return "Draw"

# Match finished
func _on_match_time_manager_match_ended():
	
	matchEnded = true
	match self.winner():
		"Player":
			endPanel.text("Player ONE WON!")
			endPanel.win()
		"Enemy":
			endPanel.text("Player TWO WON!")
			endPanel.win()
		"Draw":
			endPanel.text("Results: DRAW!")
			endPanel.draw()
	
	player.disable()
	enemy.disable()
	
	matchFinishedSound.play()
	await get_tree().create_timer(0.5).timeout
	endPanel.reveal()
