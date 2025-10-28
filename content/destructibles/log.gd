class_name Log extends Destructible

@export var push_curve : Curve

@onready var left_sprite: Sprite2D = %LeftSprite
@onready var right_sprite: Sprite2D = %RightSprite

var hit_needed := 3

func destroy():
	hit_needed -= 1
	if hit_needed == 0:
		animation_player.play("destruct")
		await animation_player.animation_finished
		queue_free.call_deferred()
	else:
		update_log()
		
func update_log():
	match(hit_needed):
		2:
			sprite.hide()
			left_sprite.rotation_degrees = 13.5
			death_visuals.show()
			launch_push_tween()
		1:
			right_sprite.rotation_degrees = -11.5
			launch_push_tween()

func launch_push_tween():
	var destroy_tween = create_tween()
	destroy_tween.tween_property(death_visuals, "position:y", 2., 0.3).as_relative().set_custom_interpolator(push_curve.sample_baked)
