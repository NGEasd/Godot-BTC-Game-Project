extends Node2D

var score_player : int = 0
var score_enemy : int = 0
var ended : bool

@onready var player_score_panel_a = 
var timer
var player
var ball
var joystick

func _ready():
	score_player = 0
	score_enemy = 0
	ended = false
	
	score_panel = get_node("/root/Pitch/Sprite2D/GameManager/ScorePanel")
	timer = get_node("/root/Pitch/Sprite2D/GameManager/MatchTimer")
	player = get_node("/root/Pitch/PlayerDisc")
	ball = get_node("/root/Pitch/Ball")
	joystick = get_node("/root/Pitch/PlayerController/Test/UI/VirtualJoystick")

	if not timer:
		print("Error: Timer node not found.")
	if not score_panel:
		print("Error: ScorePanel node not found.")
	if not player:
		print("Error: Player not connected!")
	if not ball:
		print("Error: Ball not connected!")
	if not joystick:
		print("Error: Joystick not connected!")

func add_goal(goal_name: int):
	if not ended:
		match goal_name:
			1:
				score_enemy += 1
			2:
				score_player += 1

		print("Player: ", score_player, " - Enemy: ", score_enemy)

		if score_panel:
			score_panel.update_scores(score_player, score_enemy)
		else:
			print("Error: ScorePanel node not found when updating scores.")

		if timer:
			timer.pause()
			await get_tree().create_timer(2.0).timeout
			player.reset()
			ball.reset()
		else:
			print("Error: Timer node not found when stopping and restarting.")	

func set_match_finished():
	ended = true

func winner() -> int:
	print(score_enemy, " - ", score_player)
	if score_player > score_enemy:
		return 1
	elif score_enemy > score_player:
		return 2
	else:
		return 0
