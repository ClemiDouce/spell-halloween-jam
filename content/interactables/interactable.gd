class_name Interactable extends Area2D

@export var action_label : Label
@export var interact_name : String = ""
@export var is_interactable := true

var interaction : Callable = func(): pass

func _ready() -> void:
	assert(label, "No label given")
	action_label.hide()
