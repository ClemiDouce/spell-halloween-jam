class_name FireCamp
extends Interactable

@onready var rock_sprite: Sprite2D = %RockSprite
@onready var grass_sprite: Sprite2D = %GrassSprite
@onready var wood_sprite: Sprite2D = %WoodSprite
@onready var fire_sprite: AnimatedSprite2D = %FireSprite

@export var end_dialog_position: Marker2D
@export var dev_interaction: DialogueInteractable

var dev_talked := false

@export var zone: Zone
var step := 0

func _ready() -> void:
	super()
	Events.inventory_picked.connect(on_inventory_picked)
	dev_interaction.interacted.connect(on_dev_talked)
	interaction = _on_interact
	interaction_label.text = "Find the Inventory System first"

func _on_interact(_player: Player):
	var success := false
	match(step):
		0: # Need Stones
			if Inventory.rock >= 5:
				success = true
		1: # Need Grass
			if Inventory.grass >= 40:
				success = true
		2: # Need Wood
			if Inventory.wood >= 10:
				success = true
		_:
			success = true
	
	if !success:
		return
	is_interactable = false
	
	match(step):
		0:
			Inventory.remove_ressource("rock", 5)
			rock_sprite.show()
			zone.play_zone_dialogue(1, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			interaction_label.text = "40 Grass - Add fire starter"
		1:
			Inventory.remove_ressource("grass", 40)
			grass_sprite.show()
			zone.play_zone_dialogue(2, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			interaction_label.text = "10 Wood - Add logs"
		2:
			Inventory.remove_ressource("wood", 10)
			wood_sprite.show()
			zone.play_zone_dialogue(3, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			interaction_label.text = "Start Firecamp"
		3:
			interaction_label.queue_free()
			fire_sprite.show()
			zone.play_zone_dialogue(4, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			get_tree().change_scene_to_file("res://data/dialogue/zones/zombie/end_screen.tscn")
			# End of the game
	step += 1
	is_interactable = true

func on_inventory_picked():
	interaction_label.text = "5 Stones - Start Firecamp"
	
func on_dev_talked():
	is_interactable = true
	interaction_particle.emitting = true
