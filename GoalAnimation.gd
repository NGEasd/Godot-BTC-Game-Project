extends Node2D

@onready var animation = $animation
@onready var sound = $goal
	
func _ready():
	self.visible = false

# playing the goal animation
func play() -> void:
	self.visible = true
	if animation.has_animation("goal_animation"):
		animation.play("goal_animation")
	else:
		print("Animation not found!")
	sound.play()
	await get_tree().create_timer(4.5).timeout
	self.visible = false



