class_name Rock extends Destructible

var hit_needed := 4

func destroy():
	hit_needed -= 1
	if hit_needed == 0:
		destroyed.emit()
		Inventory.add_ressource("rock")
		animation_player.play("destruct")
		await animation_player.animation_finished
		queue_free.call_deferred()
	else:
		animation_player.play("wiggle")
