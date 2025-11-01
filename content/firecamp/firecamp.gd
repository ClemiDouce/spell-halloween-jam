class_name FireCamp
extends Interactable

@onready var rock_sprite: Sprite2D = %RockSprite
@onready var grass_sprite: Sprite2D = %GrassSprite
@onready var wood_sprite: Sprite2D = %WoodSprite
@onready var fire_sprite: AnimatedSprite2D = %FireSprite

@export var end_dialog_position: Marker2D

@export var zone: Zone
var step := 0

func _ready() -> void:
	super()
	interaction = _on_interact
	interaction_label.text = "10 stone - Craft Fire camp"

func _on_interact(_player: Player):
	var success := false
	match(step):
		0: # Need Stones
			if Inventory.rock >= 3:
				success = true
		1: # Need Grass
			if Inventory.grass >= 20:
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
			rock_sprite.show()
			zone.play_zone_dialogue(1, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			interaction_label.text = "40 Grass - Add fire starter"
		1:
			grass_sprite.show()
			zone.play_zone_dialogue(2, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			interaction_label.text = "15 Wood - Add fire starter"
		2:
			wood_sprite.show()
			zone.play_zone_dialogue(3, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			interaction_label.text = "Start Firecamp"
		3:
			interaction_label.queue_free()
			fire_sprite.show()
			zone.play_zone_dialogue(4, end_dialog_position.global_position)
			await DialogueManager.dialogue_finished
			await get_tree().create_timer(1.2).timeout
			get_tree().change_scene_to_file("res://data/dialogue/zones/zombie/end_screen.tscn")
			# End of the game
	step += 1
	is_interactable = true
