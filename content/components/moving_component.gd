class_name MovableComponent extends Area2D

@export var target: Sprite2D

@export var skew_value := 12.
@export var bend_speed := 0.3
@export var back_speed := 5.

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D):
	var direction = global_position.direction_to(body.global_position).normalized()
	var skew_direction = -direction.x * skew_value
	var tween = create_tween()
	tween.tween_property(target, "skew", deg_to_rad(skew_direction), bend_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(target, "skew", 0.0, back_speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
