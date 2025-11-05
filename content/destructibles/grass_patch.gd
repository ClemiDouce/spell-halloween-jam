class_name Grass extends Destructible

func destroy():
	sprite.hide()
	destroyed.emit()
	hit_sound_player.play()
	Inventory.add_ressource("grass")
	animation_player.speed_scale = 1.
	animation_player.play("destruct")
	await animation_player.animation_finished
	queue_free()
