extends Node2D

signal finished

func _ready():
	self.hide()

# signal mechanism to decide which disc comes into play
func _on_basic_finished():
	finished.emit()

func _on_small_finished():
	finished.emit()

func _on_big_finished():
	finished.emit()
