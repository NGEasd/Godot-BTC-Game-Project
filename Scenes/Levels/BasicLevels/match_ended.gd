extends Node2D

@onready var result := $Results
@onready var lostPhoto := $LostPhoto
@onready var drawPhoto := $DrawPhoto
@onready var winPhoto := $WinPhoto
@onready var buttonSound := $ButtonPressedAudio
@onready var nextButton = $NextButton

func _ready():
	lostPhoto.hide()
	drawPhoto.hide()
	winPhoto.hide()
	self.hide()
	
func text(msg : String) -> void:
	result.text = msg

func lost() -> void:
	lostPhoto.show()
	
func draw() -> void:
	drawPhoto.show()

func win() -> void:
	winPhoto.show()
	
func reveal() -> void:
	self.show()

func _on_button_pressed():
	buttonSound.play()
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://Scenes/MainGame/arena_select_menu.tscn")
