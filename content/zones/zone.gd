class_name Zone extends Area2D

@export var zone_name : String
@export var destructibles_parent : Node2D

var total_destructibles : int = 0
var destructible_progress : int = 0

@export var dialogues_steps : Array[Dialogue]
var last_dialogue_index := -1
var player : Player

func _ready() -> void:
	body_entered.connect(on_player_entered_zone)
	body_exited.connect(func(_body): player = null)
	for node in destructibles_parent.get_children():
		if node is Destructible:
			total_destructibles += 1
			node.destroyed.connect(on_destructible_destroyed)

func on_destructible_destroyed():
	destructible_progress += 1
	Events.zone_progress_changed.emit()
	var progress_pourcent = float(destructible_progress) / total_destructibles
	var dialogue_index : int  = -1
	if progress_pourcent == 1.:
		dialogue_index = 3
	elif progress_pourcent > 0.75:
		dialogue_index = 2
	elif progress_pourcent > 0.50:
		dialogue_index = 1
	elif progress_pourcent > 0.25:
		dialogue_index = 0
	if dialogue_index != -1 and dialogue_index > last_dialogue_index:
		last_dialogue_index = dialogue_index
		DialogueManager.start_dialog(self.global_position + Vector2(250, 135), dialogues_steps[dialogue_index].lines, true)

func on_player_entered_zone(body: Node2D):
	Events.player_entered_zone.emit(self)
	player = body as Player
	
