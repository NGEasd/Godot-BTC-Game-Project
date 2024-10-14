extends Node2D

@onready var disc = $PlayerDisc
@onready var controller = $PlayerDisc/PlayerController/Test/UI/VirtualJoystick

func reset() -> void:
	disc.reset()
	
func disable() -> void:
	controller.hide()

func enable() -> void:
	controller.show()

func set_speed(value : float) -> void:
	disc.set_maxspeed(value)

func set_acceleration(value : float) -> void:
	disc.set_acceleration(value)
