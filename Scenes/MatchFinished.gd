extends Control

var results_label

func _ready():
	results_label = $Sprite2D/Results
	
func set_finished(result: String) -> void:
	results_label.text = result
	self.visible = true;
