extends Node

# saving the currentLevel into a text file
@onready var savePath = "user://current_level.txt" 
var currentLevel := 1
var levelPath

func _ready():
	loading()
	print("Current level: ", currentLevel)
	levelPath = "res://AdventureMode/Levels/level_" + str(currentLevel).pad_zeros(2) + ".tscn"
	print(str(levelPath))

var discs = {
	"basic": {"unlocked": true, "path": "res://Scenes/Discs_Players/disc_one.tscn"},
	"small": {"unlocked": true, "path": "res://Scenes/Discs_Players/disc_two.tscn"},
	"big": {"unlocked": true, "path": "res://Scenes/Discs_Players/disc_three.tscn"}
}

var player_positions : Array[Vector2] = [
	Vector2(1287, 907), 
	Vector2(1236, 962),
	Vector2(1258, 832),
	Vector2(1167, 1030),
	Vector2(1242, 1004),
	Vector2(1208, 1001)    
]

func unlocked(discName: String) -> bool:
	return discs[discName]["unlocked"]

# advance level
func advance_level():
	currentLevel += 1
	save()  # automatic save

func refresh_level_path():
	levelPath = "res://AdventureMode/Levels/level_" + str(currentLevel).pad_zeros(2) + ".tscn"

# disc selection method
func select_disc(name: String) -> void:
	if name in discs:
		var disc_info = discs[name]
		if disc_info["unlocked"]:
			var disc_scene = load(disc_info["path"])
			var disc_instance = disc_scene.instantiate()
			get_tree().current_scene.add_child(disc_instance)
		else:
			print("Disc is locked and cannot be instantiated.")

# initial positions on different levels for player disc
func get_inicial_position() -> Vector2:
	if currentLevel <= 4:
		return player_positions[0]
	elif currentLevel <= 6: 
		return player_positions[1]
	elif currentLevel <= 7:
		return player_positions[2]
	elif currentLevel <= 10:
		return player_positions[3]
	elif currentLevel == 14:
		return player_positions[5]
	else: return player_positions[4]

func save() -> void:
	# open file in write mode to clear previous contents
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_32(currentLevel)
	file.close()
	print("File saved successfully.")

func loading() -> void:
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		currentLevel = file.get_32()
		file.close()
		print("File loaded successfully. Current level: ", currentLevel)
	else:
		# if the file is empty, its a new user
		print("Save file does not exist. Setting default value.")
		currentLevel = 1
		save()  
