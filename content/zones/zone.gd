class_name Zone extends Area2D

@export var zone_name : String
@export var destructibles_parent : Node2D

var total_destructibles : int = 0
var destructible_progress : int = 0


func _ready() -> void:
	body_entered.connect(on_player_entered_zone)
	for node in destructibles_parent.get_children():
		if node is Destructible:
			total_destructibles += 1
			node.destroyed.connect(on_destructible_destroyed)

func on_destructible_destroyed():
	destructible_progress += 1
	Events.zone_progress_changed.emit()

func on_player_entered_zone(_body: Node2D):
	Events.player_entered_zone.emit(self)
	
