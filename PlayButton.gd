extends Node2D

@onready var buttonText = $Label
@onready var level = $LevelNumber
@onready var sound = $Beep
@onready var completed = $AdventureCompleted

# setting the play button
func _ready():
	if AdventureManager.currentLevel <= 15: level.text = "LEVEL " + str(AdventureManager.currentLevel)
	if AdventureManager.currentLevel == 1 : show_start()
	if AdventureManager.currentLevel > 1 : show_continue()
	if AdventureManager.currentLevel > 15: 
		level.text = "Congratulations!"
		buttonText.text = "Adventure COMPLETED!"

func show_start():
	buttonText.text = "START Adventure"

func show_continue():
	buttonText.text = "CONTINUE Adventure"

func _on_button_pressed():
	sound.play()
	await get_tree().create_timer(0.3).timeout
	if AdventureManager.currentLevel <= 15:
		get_tree().change_scene_to_file(AdventureManager.levelPath)
	else: completed.show()
