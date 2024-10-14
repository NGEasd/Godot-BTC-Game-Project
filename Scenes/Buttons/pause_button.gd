extends Button

@onready var menu = $PauseMenu
@onready var buttonSound = $Beep

func _ready():
	menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	menu.hide()

func _on_pressed():
	buttonSound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = true
	menu.show()

func _on_back_button_pressed():
	buttonSound.play()
	await get_tree().create_timer(0.3).timeout
	menu.hide()
	get_tree().paused = false

func _on_quit_button_pressed():
	buttonSound.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Scenes/MainGame/arena_select_menu.tscn")
