extends Control

var label1
var label2

# Called when the node enters the scene tree for the first time.
func _ready():
	label1 = $PTS1
	label2 = $PTS2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_scores(score1, score2):
	label1.text = str(score1)
	label2.text = str(score2)

