extends Node2D

@onready var button_sound = $ButtonPressedAudio

# quit
func _on_button_pressed():
	button_sound.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().quit()

# 1v1
func _on_v_1_pressed():
	button_sound.play()
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://Scenes/MainGame/arena_select_menu.tscn")

# adventure
func _on_adventure_pressed():
	button_sound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://AdventureMode/MainMenu/adventure_menu.tscn")
