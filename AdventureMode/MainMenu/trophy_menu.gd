extends Node2D

@onready var zeroThropy = $NoTrophyLabel
@onready var bronze = $BronzeTrophy
@onready var silver = $SilverTrophy
@onready var champion = $ChampionTrophy

func _ready():
	present_trophies()

func present_trophies():
	if AdventureManager.currentLevel < 6: 
		zeroThropy.show()
		bronze.hide()
		silver.hide()
		champion.hide()
	elif AdventureManager.currentLevel <= 10: 
		zeroThropy.hide()
		bronze.show()
		silver.hide()
		champion.hide()
	elif AdventureManager.currentLevel < 16: 
		zeroThropy.hide()
		bronze.show()
		silver.show()
		champion.hide()
	else:
		zeroThropy.hide()
		bronze.show()
		silver.show()
		champion.show()


