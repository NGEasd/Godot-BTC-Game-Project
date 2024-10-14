extends Sprite2D

@onready var sound = $"../ButtonPressedAudio"
@onready var selector = $".."
@onready var newLabel = $"../NewLabelSmall"

signal finished

# showing the disc if it is unlocked
func _ready():
	if AdventureManager.unlocked("small"):
		self.show()
	else: self.hide()
	# in the first level, we mark the disc as 'new'
	if AdventureManager.currentLevel != 4:
		newLabel.hide()

# selecting the disc with the autoload AdventureManager script
func _on_selector_pressed():
	sound.play()
	AdventureManager.select_disc("small")
	await get_tree().create_timer(0.3).timeout
	selector.hide()
	finished.emit()
