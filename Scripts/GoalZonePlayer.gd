extends Area2D

var game_manager

func _ready():
	game_manager = get_node("/root/Pitch/Sprite2D/GameManager")
	
func _on_body_entered(body):
	print("Entered player goal zone")
	if body.name == "Ball":
		game_manager.add_goal(1)
