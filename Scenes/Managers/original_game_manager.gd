extends Node2D

# variables for match tracking
@export var playerScore : int
@export var enemyScore : int
var goal : bool
var matchEnded : bool

# score panels
@onready var playerScorePanelA := $"../ResultTableA1"
@onready var playerScorePanelB := $"../ResultTableA2"
@onready var enemyScorePanelA := $"../ResultTableB1"
@onready var enemyScorePanelB := $"../ResultTableB2"

# players
@onready var player  # := $"../PlayerOne"
@onready var enemy := $"../EnemyDisc"

# ball
@onready var ball := $"../SimpleBall"

# timers
@onready var timer = $"../MatchTimeManager"

# countdown animation
@onready var countdown := $StartingAnimation

# Match Finished Table and Results Manager
@onready var endPanel := $"../MatchEnded"

# goal Animations
@onready var goalAnimationPlayer := $"../GoalAnimationPlayer"
@onready var goalAnimationEnemy := $"../GoalAnimationEnemy"

# sounds
@onready var kickOffSound := $"../KickOffSound"
@onready var matchFinishedSound := $"../MatchFinishedSound"

# tutorial
@onready var tutorial := $"../../Tutorial"

# disc selector
@onready var discSelector = $"../../DiscSelector"

# reward tab
@onready var trophyRoom = $"../../TrophyReward"

# goalkeeper (not every time)
var gk

# initialiying
func _ready() -> void:
	
	# player.disable()
	enemy.disable()
	
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
	
	if countdown and not tutorial:
		countdown.start()
	else: tutorial.show()
	
	# gk appereance on specific levels
	if AdventureManager.currentLevel == 5 or AdventureManager.currentLevel == 9 or AdventureManager.currentLevel == 12 or AdventureManager.currentLevel == 15:
		gk = $"../GoalKeeperStatic"

# when the starting animation finished, we start the match
func _on_starting_animation_animation_finished():
	player.enable()
	enemy.enable()
	timer.start()

# score managing
func add_goal(id : int) -> void:
	if not goal and not matchEnded:
		goal = true
		
		if gk: gk.disable()
		
		enemy.disable()
		
		# 1 - player
		# 2 - enemy
		# updating the scores and changing the numbers on the label
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
		
		# pausing the timer for 5 seconds
		await(timer.pause())
		
		# reset the positions 
		player.reset()
		enemy.reset()
		ball.reset()
		
		await get_tree().create_timer(0.2).timeout
		if gk: gk.enable()
		
		# playing the kickoff sound
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

# match finished
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
			endPanel.text("DRAW! (Unlucky)")
			endPanel.lost()
			endPanel.reveal()
	
	player.disable()
	enemy.disable()
	await get_tree().create_timer(0.5).timeout

# after the tutorial, the disc selector comes 
func _on_tutorial_finished():
	if discSelector: discSelector.show()
	else:
		player = $"../PlayerOne"
		player.disable()
		countdown.start()

# after selecting the playing disc, the countdown stats
func _on_disc_selector_finished():
	player = $"../../PlayerOne"
	player.disable()
	countdown.start()

func _on_trophy_reward_finished():
	endPanel.reveal()
