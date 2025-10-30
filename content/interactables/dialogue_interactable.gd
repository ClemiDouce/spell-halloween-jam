class_name DialogueInteractable
extends Interactable

@export var dialogue_lines : Array[String]
@export var cinematic := false

func _ready() -> void:
	super()
	interaction = _on_interact
	
func _on_interact():
	DialogueManager.start_dialog(self.global_position, dialogue_lines, cinematic)
	await DialogueManager.dialogue_finished
