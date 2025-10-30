class_name CinematicEffect extends Control

@onready var cinema_player: AnimationPlayer = %CinemaPlayer
var active := false

func _ready() -> void:
	DialogueManager.cinema_effect = self

func cinema_in():
	active = true
	cinema_player.play("cinema_in")
	await cinema_player.animation_finished
	
func cinema_out():
	active = false
	cinema_player.play("cinema_out")
	await cinema_player.animation_finished
