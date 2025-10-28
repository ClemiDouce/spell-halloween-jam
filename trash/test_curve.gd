extends Node2D

@export var curve: Curve
@export var target_rotation := 90.
@onready var cactus_sprite: Sprite2D = %CactusSprite

func _ready() -> void:
	launch_tween()

func launch_tween():
	var tween = create_tween()
	tween.tween_property(cactus_sprite, "rotation_degrees", 90., 1.5).set_custom_interpolator(Global.tween_curve.bind(curve))
