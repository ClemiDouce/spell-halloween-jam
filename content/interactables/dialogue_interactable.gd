class_name DialogueInteractable
extends Interactable

signal interacted

@export var dialogue_lines : Array[String]
@export var cinematic := false

func _ready() -> void:
	super()
	interaction = _on_interact
	
func _on_interact(player: Player):
	if interaction_particle:
		interaction_particle.emitting = false
	DialogueManager.start_dialog(player.dialogue_position.global_position, dialogue_lines, cinematic)
	await DialogueManager.dialogue_finished
	interacted.emit()
