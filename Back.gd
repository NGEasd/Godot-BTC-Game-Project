extends Node2D

@onready var tap = $Beep

func _on_button_pressed():
	tap.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/MainGame/menu.tscn")
