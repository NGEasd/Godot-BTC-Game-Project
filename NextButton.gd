extends Node2D

@onready var label = $Label
@onready var sound = $Beep

func continue_button():
	if AdventureManager.currentLevel < 16:
		print(str(AdventureManager.currentLevel))
		label.text = "CONTINUE"
		print("BUTTON CHANGED")

func retry_button():
	label.text = "RETRY"
	print("BUTTON CHANGED")

func _on_button_pressed():
	sound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file(AdventureManager.levelPath)
