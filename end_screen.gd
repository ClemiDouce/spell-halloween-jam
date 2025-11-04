extends Control

func _ready() -> void:
	Inventory.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_tree().quit()
