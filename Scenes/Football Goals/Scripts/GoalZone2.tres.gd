extends Area2D

var gameManager

# connecting to game manager
func _ready():
	gameManager = $"../../BasicGameManager"
	if not gameManager:
		print("Error - no gamemanager!")

# if the ball enters the scoring zone, we add a goal
func _on_body_entered(body):
	if body.name == "SimpleBall" and gameManager:
		gameManager.add_goal(2)
