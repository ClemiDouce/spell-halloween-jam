class_name Destructible extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var death_visuals: Node2D = $DeathVisuals

signal destroyed

func _ready() -> void:
	pass
	#animation_player.speed_scale = randf_range(0.8, 1.2)
	#animation_player.play("wind")

func destroy():
	sprite.hide()
	destroyed.emit()
	animation_player.speed_scale = 1.
	animation_player.play("destruct")
	await animation_player.animation_finished
	queue_free()
