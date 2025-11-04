class_name Interactable extends Area2D

@export var interaction_label : Label
@export var interact_name : String = ""
@export var is_interactable := true
@export var interaction_particle := CPUParticles2D

var interaction : Callable = func(): pass

func _ready() -> void:
	#interaction_label.text = interact_name
	interaction_label.hide()


func show_prompt():
	if interaction_label:
		interaction_label.show()
	
func hide_prompt():
	if interaction_label:
		interaction_label.hide()
