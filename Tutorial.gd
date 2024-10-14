extends Node2D

# path for JSON text file, the tutorial text
@export var json_file_path: String

signal finished

var messages = []
var iterator := 0

@onready var animator := $Speaker
@onready var msg := $Label
@onready var beep := $Beep

func _ready():
	load_messages(json_file_path)
	animator.visible = true
	if messages.size() > 0:
		msg.text = messages[0]

# loading message (assisted by gpt)
func load_messages(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		file.close()
		var json = JSON.new()
		var error = json.parse(data)
		if error == OK:
			var parsed_data = json.get_data()
			if parsed_data.has("messages"):
				messages = parsed_data["messages"]
			else:
				print("Error: 'messages' key not found in the JSON file.")
		else:
			print("Error parsing JSON: ", error)
	else:
		print("Error loading file: ", file_path)

func _on_button_pressed():
	beep.play()
	await get_tree().create_timer(0.1).timeout
	iterator += 1
	if iterator >= messages.size():
		finished.emit()
		self.visible = false
	else: 
		# iterating trought the json file text
		msg.text = messages[iterator]
