extends StaticBody2D

@export var speed : float = 200.0
var direction : int = 1
var disabled : bool = false

func _physics_process(delta: float) -> void:
	# Kapus kézi mozgatása jobbra-balra
	if not disabled:
		var new_position = position + Vector2(speed * direction * delta, 0)
		position = new_position

func enable():
	disabled = false

func disable():
	disabled = true

func change_direction() -> void:
	# Irányváltás
	direction *= -1

func _on_area_2d_body_entered(body):
	if body is StaticBody2D:
		change_direction()
	if body.name == "SimpleBall":
		var kickDirection = (body.get_global_position() - global_position).normalized()
		body.apply_central_impulse(kickDirection * 60)
