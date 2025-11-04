class_name InteractionDetector extends Area2D

@export var interaction_label : Label
var current_interaction : Array[Interactable]
var can_interact := true

func _ready() -> void:
	area_entered.connect(on_interactable_entered)
	area_exited.connect(on_interactable_exited)

func _input(event: InputEvent):
	if event.is_action_pressed("interact") and can_interact:
		if current_interaction and can_interact:
			for interaction in current_interaction:
				if interaction.is_interactable:
					on_interaction(interaction)
					return
				else:
					continue

func _process(_delta: float) -> void:
	if current_interaction and can_interact:
		var first_interaction := false
		current_interaction.sort_custom(_sort_by_nearest)
		for i in current_interaction.size():
			var _inter = current_interaction[i]
			if _inter.is_interactable and first_interaction == false:
				first_interaction = true
				current_interaction[i].show_prompt()
			else:
				if _inter.is_interactable:
					current_interaction[i].hide_prompt()

func on_interactable_entered(area: Area2D):
	current_interaction.push_back(area as Interactable)
	
func on_interactable_exited(area: Area2D):
	area.hide_prompt()
	current_interaction.erase(area)
	
func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist
	
func on_interaction(area: Interactable):
	can_interact = false
	area.hide_prompt()
	await area.interaction.call(owner)
	area.show_prompt()
	can_interact = true
