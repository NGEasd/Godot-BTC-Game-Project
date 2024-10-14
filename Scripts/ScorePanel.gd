extends Control

@onready var player_label =  $PlayerPTS 
@onready var enemy_label = $EnemyPTS

func _ready():
	pass

func update_scores(player_score, enemy_score):
	player_label.text = str(player_score)
	enemy_label.text = str(enemy_score)
