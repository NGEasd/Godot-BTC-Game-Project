extends Node2D

@onready var label = $Label
@onready var sound = $Beep

func _on_button_pressed():
	sound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/MainGame/arena_select_menu.tscn")
