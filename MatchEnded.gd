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
	print("lost")
	lostPhoto.show()

func draw() -> void:
	drawPhoto.show()

func win() -> void:
	print("win")
	winPhoto.show()

func reveal() -> void:
	self.show()

