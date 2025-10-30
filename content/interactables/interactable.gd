class_name Interactable extends Area2D

@export var interaction_label : Label
@export var interact_name : String = ""
@export var is_interactable := true

var interaction : Callable = func(): pass

func _ready() -> void:
	interaction_label.text = interact_name
	interaction_label.hide()


func show_prompt():
	interaction_label.show()
	
func hide_prompt():
	interaction_label.hide()
