extends Node2D

@onready var disc = $PlayerDisc
@onready var controller = $PlayerDisc/PlayerController/Test/UI/VirtualJoystick

func reset() -> void:
	disc.reset()
	
func disable() -> void:
	disc.disable_movement()
	controller.hide()

func enable() -> void:
	disc.enable_movement()
	controller.show()

func set_speed(value : float) -> void:
	disc.set_maxspeed(value)

func set_default_position(pos : Vector2):
	disc.setdefpos(pos)
