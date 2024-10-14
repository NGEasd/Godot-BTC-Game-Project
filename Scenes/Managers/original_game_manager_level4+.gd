extends Node2D

# Variables for match tracking
@export var playerScore : int
@export var enemyScore : int
var goal : bool
var matchEnded : bool

# Score panels
@onready var playerScorePanelA := $"../ResultTableA1"
@onready var playerScorePanelB := $"../ResultTableA2"
@onready var enemyScorePanelA := $"../ResultTableB1"
@onready var enemyScorePanelB := $"../ResultTableB2"

# Players
@onready var player  # := $"../PlayerOne"
@onready var enemy := $"../EnemyDisc"

# Ball
@onready var ball := $"../SimpleBall"

# Timers
@onready var timer = $"../MatchTimeManager"

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

# Tutorial (not for all levels)
@onready var tutorial := $"../../Tutorial"

# Disc selector
@onready var discSelector = $"../../DiscSelector"

# Reward tab
@onready var trophyRoom = $"../../TrophyReward"

# Goalkeeper
var gk

# Initialiying
func _ready() -> void:
	
	# player.disable()
	enemy.disable()
	
	goal = false
	matchEnded = false
	
	if playerScorePanelA and playerScorePanelB:
		playerScorePanelA.text = str(playerScore)
		playerScorePanelB. text = str(playerScore)
		
	if enemyScorePanelA and enemyScorePanelB:
		enemyScorePanelA.text = str(enemyScore)
		enemyScorePanelB. text = str(enemyScore)
	
	if countdown and not tutorial:
		countdown.start()
	else: tutorial.show()
	
	# kapus: level 5, 9, 12, 15
	if AdventureManager.currentLevel == 5 or AdventureManager.currentLevel == 9 or AdventureManager.currentLevel == 12 or AdventureManager.currentLevel == 15:
		gk = $"../GoalKeeperStatic"

# When the stating animation finished, we start the match
func _on_starting_animation_animation_finished():
	player.enable()
	enemy.enable()
	timer.start()

# Function for score managing
func add_goal(id : int) -> void:
	if not goal and not matchEnded:
		goal = true
		
		if gk: gk.disable()
		
		enemy.disable()
		
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
		
		await get_tree().create_timer(0.2).timeout
		if gk: gk.enable()
		
		# Playing the kickoff sound
		kickOffSound.play()
		enemy.enable()
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
	matchFinishedSound.play()
	match self.winner():
		"Player":
			AdventureManager.advance_level()
			AdventureManager.refresh_level_path()
			endPanel.win()
			endPanel.text("YOU WON!")
			if trophyRoom: trophyRoom.reward()
			else: endPanel.reveal()
		"Enemy":
			endPanel.text("YOU LOST!")
			endPanel.lost()
			endPanel.reveal()
		"Draw":
			print("Draw!")
			endPanel.text("DRAW! (Unlucky)")
			endPanel.lost()
			endPanel.reveal()
	
	player.disable()
	enemy.disable()
	await get_tree().create_timer(0.5).timeout

func _on_tutorial_finished():
	discSelector.show()

func _on_disc_selector_finished():
	player = $"../../PlayerOne"
	player.disable()
	countdown.start()

func _on_trophy_reward_finished():
	endPanel.reveal()
