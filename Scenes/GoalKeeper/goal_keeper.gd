extends CharacterBody2D

@export var speed : float = 200.0
var direction : int = 1

func _physics_process(delta: float) -> void:
	# Mozgás irányának beállítása
	velocity.x = speed * direction
	
	# Mozgás a megadott velocity szerint
	move_and_slide()

	# Irányváltás, ha a karakter falnak ütközik
	if is_on_wall():
		change_direction()

func change_direction() -> void:
	direction *= -1
