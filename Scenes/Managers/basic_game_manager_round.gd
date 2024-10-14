extends Node2D

# Variables for match tracking
var playerScore : int
var enemyScore : int
var goal : bool
var matchEnded : bool

# Score panels
@onready var playerScorePanelA := get_node("/root/RoundLevel1v1/ResultTableA1")
@onready var playerScorePanelB := get_node("/root/RoundLevel1v1/ResultTableA2")
@onready var enemyScorePanelA := get_node("/root/RoundLevel1v1/ResultTableB1")
@onready var enemyScorePanelB := get_node("/root/RoundLevel1v1/ResultTableB2")

# Players
@onready var player := get_node("/root/RoundLevel1v1/PlayerOne")
@onready var enemy := get_node("/root/RoundLevel1v1/PlayerTwo")

# Ball
@onready var ball := get_node("/root/RoundLevel1v1/SimpleBall")

# Timers
@onready var timer = get_node("/root/RoundLevel1v1/MatchTimeManager")

# Countdown animation
@onready var countdown := $StartingAnimation

# Match Finished Table and Results Manager
@onready var endPanel := get_node("/root/RoundLevel1v1/MatchEnded")

# Goal Animations
@onready var goalAnimationPlayer := get_node("/root/RoundLevel1v1/GoalAnimationPlayer")
@onready var goalAnimationEnemy := get_node("/root/RoundLevel1v1/GoalAnimationEnemy")

# Sounds
@onready var kickOffSound := get_node("/root/RoundLevel1v1/KickOffSound")
@onready var matchFinishedSound := get_node("/root/RoundLevel1v1/MatchFinishedSound")

# Initialiying
func _ready() -> void:
	
	player.disable()
	enemy.disable()
	
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
		player.reset()
		enemy.reset()
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
			endPanel.win()
			endPanel.text("Player ONE WON!")
		"Enemy":
			endPanel.text("Player TWO WON!")
			endPanel.win()
		"Draw":
			endPanel.text("DRAW!")
			endPanel.draw()
	
	player.disable()
	enemy.disable()
	
	matchFinishedSound.play()
	await get_tree().create_timer(0.5).timeout
	endPanel.reveal()
