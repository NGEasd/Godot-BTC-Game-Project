extends Control

@onready var buttonSound := $ButtonPressedAudio
@onready var tap := $Beep

func _ready():
	if not buttonSound:
		print("Button Sound not found!")
	if not tap:
		print("Tap not found!")

# basic arena
func _on_basic_arena_button_pressed():
	tap.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/BasicLevels/basic_level_1v1.tscn")

# skating park
func _on_skating_park_button_pressed():
	tap.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/BasicLevels/ice_level_1v_1.tscn")

# round arena
func _on_coliseum_button_pressed():
	tap.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/Levels/BasicLevels/round_level_1v_1.tscn")

# back
func _on_back_button_pressed():
	buttonSound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Scenes/MainGame/menu.tscn")
