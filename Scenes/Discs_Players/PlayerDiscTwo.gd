extends RigidBody2D

# Properties
@export var speed := 475.0
@export var impulse_strength = 1

var joystick : VirtualJoystick
var target_velocity := Vector2.ZERO

var def_pos := Vector2.ZERO
var reset_state := false
var movement := true

func _ready():
	joystick = $PlayerController/Test/UI/VirtualJoystick
	if not joystick:
		print("Joystick not found!")
	global_position = AdventureManager.get_inicial_position()
	def_pos = global_position

func _process(delta):
	if joystick.is_pressed and movement:
		var direction = joystick.output.normalized()
		target_velocity = direction * speed

func _integrate_forces(state) -> void:
	if reset_state:
		state.transform = Transform2D(0.0, def_pos)
		target_velocity = Vector2.ZERO
		reset_state = false
	else:
		linear_velocity = target_velocity.normalized() * speed
		for i in range(state.get_contact_count()):
			var contact_collider = state.get_contact_collider_object(i) 
			if contact_collider and contact_collider.name == "SimpleBall":
				var contact_point = state.get_contact_local_position(i)  # Ütközési pont a test koordinátarendszerében
				var direction = (contact_collider.get_global_position() - contact_point).normalized()
				contact_collider.apply_central_impulse(direction * impulse_strength)

func reset():
	reset_state = true
	
func get_speed() -> Vector2:
	return linear_velocity	

func set_maxspeed(value : float) -> void:
	speed = value

func enable_movement() -> void:
	movement = true

func disable_movement() -> void:
	movement = false

func setdefpos(pos : Vector2):
	def_pos = pos
	global_position = pos

