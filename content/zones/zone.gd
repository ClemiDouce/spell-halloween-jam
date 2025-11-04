class_name Zone extends Area2D

@export var zone_name : String
@export var destructibles_parent : Node2D

var total_destructibles : int = 0
var destructible_progress : int = 0

var first_entrance := true

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
	var center_screen = self.global_position + Vector2(250, 135)
	Events.zone_progress_changed.emit()
	var progress_pourcent = float(destructible_progress) / total_destructibles
	var dialogue_index : int  = -1
	if progress_pourcent == 1.:
		dialogue_index = 4
	elif progress_pourcent > 0.75:
		dialogue_index = 3
	elif progress_pourcent > 0.50:
		dialogue_index = 2
	elif progress_pourcent > 0.25:
		dialogue_index = 1
	if dialogue_index != -1 and dialogue_index > last_dialogue_index:
		last_dialogue_index = dialogue_index
		play_zone_dialogue(dialogue_index, center_screen)

func on_player_entered_zone(body: Node2D):
	Events.player_entered_zone.emit(self)
	player = body as Player
	if first_entrance:
		first_entrance = false
		player.tool_speed -= 0.1
		await get_tree().create_timer(0.5).timeout
		DialogueManager.start_dialog(self.global_position + Vector2(250, 135), dialogues_steps[0].lines, false)
	
func play_zone_dialogue(index: int, dialog_position: Vector2 = self.global_position + Vector2(250, 135)):
	DialogueManager.start_dialog(dialog_position, dialogues_steps[index].lines, true)
