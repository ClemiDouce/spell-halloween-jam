class_name DiscoverableComponent extends Node

@export var target : Interactable
@export var conditions : Array
@export var group_name : String

var destroyed := 0
var total := 0

func _ready() -> void:
	target.is_interactable = false
	target.hide()
	conditions = get_tree().get_nodes_in_group(group_name)
	total = conditions.size()
	for c : Destructible in conditions:
		c.destroyed.connect(on_destroyed_destructible)
	
	
func on_destroyed_destructible():
	destroyed += 1
	if destroyed >= total:
		target.is_interactable = true
		target.show()
