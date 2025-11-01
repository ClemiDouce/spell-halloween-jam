extends CanvasLayer

@onready var grass_label: Label = %GrassLabel
@onready var wood_label: Label = %WoodLabel
@onready var rock_label: Label = %RockLabel

var wood: int = 0
var rock: int = 0
var grass: int = 0

func _ready() -> void:
	#hide()
	pass

func add_ressource(ressource_name: String):
	match(ressource_name):
		"wood":
			wood += 1
			wood_label.text = str(wood)
		"rock":
			rock += 1
			rock_label.text = str(rock)
		"grass":
			grass += 1
			grass_label.text = str(grass)
	
