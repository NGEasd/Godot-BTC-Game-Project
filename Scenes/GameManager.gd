extends Node2D

var score_player1 : int = 0
var score_player2 : int = 0
var ended : bool
var score_panel
var timer
var end_label
var player1
var player2
var ball

@onready var animation = $GoalAnimation
@onready var kickoff_whistle = $KickOffSound
@onready var match_ended_whistle = $MatchFinishedSound
@onready var goal := false
@onready var button_sound = $ButtonPressedAudio
@onready var countdown = $"../../StartingAnimation"


func _ready() -> void:
	score_player1 = 0
	score_player2 = 0
	ended = false
	score_panel = $ScoreLabel
	timer = $MatchTimer
	end_label = $MatchFinished
	player1 = $"../../PlayerOne/PlayerDisc"
	player2 = $"../../PlayerTwo/PlayerDisc"
	ball = $"../../Ball"

	if not timer:
		print("Error: Timer node not found.")
	if not score_panel:
		print("Error: ScorePanel node not found.")
	else:
		score_panel.update_scores(score_player1, score_player2)
	if not end_label:
		print("Error: EndLabel node not found.")
	if not player1:
		print("Error: Player1 not connected!")
	if not player2:
		print("Error: Player2 not connected!")
	if not ball:
		print("Error: Ball not connected!")
		
	if countdown:
		countdown.start()
		
	if countdown.finished():
		timer.start()

func add_goal(goal_name: int) -> void:
	if not ended and not goal:
		goal = true
		animation.play()
		match goal_name:
			1:
				score_player1 += 1
			2:
				score_player2 += 1

		print("Player1: ", score_player1, " - Player2: ", score_player2)

		if score_panel:
			score_panel.update_scores(score_player1, score_player2)
		else:
			print("Error: ScorePanel node not found when updating scores.")

		if timer:
			timer.pause()
			await get_tree().create_timer(5.0).timeout
			player1.reset()
			player2.reset()
			ball.reset()
			kickoff_whistle.play()
		else:
			print("Error: Timer node not found when stopping and restarting.")	
			
		goal = false

func set_match_finished() -> void:
	ended = true
	match_ended_whistle.play()
	end_label.set_finished(winner())

func winner() -> String:
	print(score_player1, " - ", score_player2)
	if score_player1 > score_player2:
		return "RESULTS: Player 1 WON the match!"
	elif score_player2 > score_player1:
		return "RESULTS: Player 2 WON the match!"
	else:
		return "RESULTS: DRAW!"

func _on_button_pressed():
	button_sound.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
