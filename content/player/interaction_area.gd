class_name InteractionDetector extends Area2D

@export var interaction_label : Label
var current_interaction : Interactable = null
var can_interact := true

func _ready() -> void:
	area_entered.connect(on_interactable_entered)
	area_exited.connect(on_interactable_exited)

func _input(event: InputEvent):
	if event.is_action_pressed("interact") and can_interact:
		if current_interaction:
			can_interact = false
			#interaction_label.hide()
			current_interaction.hide_prompt()
			await current_interaction.interaction.call(owner)
			#interaction_label.show()
			current_interaction.show_prompt()
			can_interact = true

func on_interactable_entered(area: Area2D):
	current_interaction = area as Interactable
	interaction_label.text = current_interaction.interact_name
	current_interaction.show_prompt()
	
func on_interactable_exited(_area: Area2D):
	current_interaction.hide_prompt()
	current_interaction = null
	
