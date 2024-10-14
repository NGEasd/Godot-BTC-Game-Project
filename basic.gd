extends Sprite2D

@onready var sound = $"../ButtonPressedAudio"
@onready var selector = $".."

signal finished

# showing the disc if it is unlocked
func _ready():
	if AdventureManager.unlocked("basic"):
		self.show()
	else: self.hide()

# selecting the disc with the autoload AdventureManager script
func _on_selector_pressed():
	sound.play()
	AdventureManager.select_disc("basic")
	await get_tree().create_timer(0.3).timeout
	selector.hide()
	finished.emit()
