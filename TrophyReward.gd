extends Node2D

@onready var sound = $AudioStreamPlayer2D

signal finished

func _ready():
	self.hide()

func reward():
	sound.play()
	self.show()

func _on_button_pressed():
	self.hide()
	finished.emit()
